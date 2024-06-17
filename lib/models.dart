class Node {
  final String id;
  final String label;
  final double? x;
  final double? y;
  final double width;
  final double height;

  Node({
    required this.id,
    required this.label,
    this.x,
    this.y,
    required this.width,
    required this.height,
  });

  factory Node.fromJson(String id, Map<String, dynamic> json) {
    return Node(
      id: id,
      label: json['label'],
      x: json['x'],
      y: json['y'],
      width: json['width'],
      height: json['height'],
    );
  }

  // tojson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
    };
  }
}

class EdgeData {
  final String name; // Name of the edge (e.g., "A->B")
  final List<Map<String, double>>
      points; // List of points defining the edge path

  EdgeData({
    required this.name,
    required this.points,
  });

  factory EdgeData.fromJson(String name, List<dynamic> json) {
    List<Map<String, double>> points = json.map<Map<String, double>>((point) {
      return {
        'x': point['x']!,
        'y': point['y']!,
      };
    }).toList();

    return EdgeData(
      name: name,
      points: points,
    );
  }
}

class DagreEdge {
  final String source;
  final String target;
  final int weight;

  DagreEdge({
    required this.source,
    required this.target,
    this.weight = 1,
  });

  // tojson
  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'target': target,
      'weight': weight,
    };
  }
}

enum RankDirection {
  TB,
  BT,
  LR,
  RL,
}

enum Ranker {
  NETWORK_SIMPLEX,
  TIGHT_TREE,
  LONGEST_PATH;

  static String toStringRepresentation(Ranker ranker) {
    switch (ranker) {
      case Ranker.NETWORK_SIMPLEX:
        return "Network-Simplex";
      case Ranker.TIGHT_TREE:
        return "Tight-Tree";
      case Ranker.LONGEST_PATH:
        return "Longest-Path";
      default:
        throw ArgumentError("Invalid Ranker value");
    }
  }
}

String returnNextRanker(String ranker) {
  switch (ranker) {
    case 'network-simplex':
      return 'tight-tree';
    case 'tight-tree':
      return 'longest-path';
    case 'longest-path':
      return 'network-simplex';
    default:
      throw new ArgumentError("Invalid Ranker: $ranker");
  }
}

RankDirection returnNextDirection(String rankDirection) {
  switch (rankDirection) {
    case 'TB':
      return RankDirection.LR;
    case 'LR':
      return RankDirection.RL;
    case 'RL':
      return RankDirection.BT;
    case 'BT':
      return RankDirection.TB; // Start over at TB
    default:
      throw new ArgumentError("Invalid RankDirection: $rankDirection");
  }
}
