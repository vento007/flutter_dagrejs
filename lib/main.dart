import 'dart:convert';
import 'dart:js' as js;

import 'package:flutter/material.dart';

import 'jsinterop.dart';
import 'models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
              'Flutter + dagre js directed graph (js interop) POC/starter/example'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return const Center(
              child: CustomPaintedGraph(),
            );
          },
        ),
      ),
    );
  }
}

class CustomPaintedGraph extends StatefulWidget {
  const CustomPaintedGraph({super.key});

  @override
  _CustomPaintedGraphState createState() => _CustomPaintedGraphState();
}

class _CustomPaintedGraphState extends State<CustomPaintedGraph> {
  late Map<String, dynamic> nodes;
  late Map<String, dynamic> edges;
  late Map<String, dynamic> graphSize;

  List<Node> nodesList = [];
  List<EdgeData> edgesList = [];

  var slider1 = 80.0;
  var slider2 = 80.0;
  RankDirection rd = RankDirection.TB;

  List<Node> outNodeList = [];
  List<DagreEdge> outDagreEdges = [];

  @override
  void initState() {
    super.initState();

    //
    addDataset1(outNodeList, outDagreEdges);

    setJsContext();

    parse();
  }

  void clear() {
    outNodeList.clear();
    outDagreEdges.clear();

    outNodeList.add(Node(id: 'A', width: 50, height: 50, label: 'A'));
    setJsContext();
    parse();
  }

  void loadDataset1() {
    outNodeList.clear();
    outDagreEdges.clear();
    addDataset1(outNodeList, outDagreEdges);
    setJsContext();
    parse();
  }

  void loadDataset2() {
    outNodeList.clear();
    outDagreEdges.clear();
    addDataset2(outNodeList, outDagreEdges);
    setJsContext();
    parse();
  }

  void addnode(String s) {
    // get random number
    var random = new DateTime.now().millisecondsSinceEpoch;
    var lastFive = random.toString().substring(random.toString().length - 5);
    outNodeList.add(Node(id: lastFive, width: 50, height: 50, label: lastFive));
    // connect to clicked node
    outDagreEdges.add(DagreEdge(source: s, target: lastFive));
    setJsContext();
    parse();
  }

  void setJsContext() {
    js.context['myJsNodes'] = js.JsObject.jsify(outNodeList.map((node) {
      return node.toJson();
    }).toList());

    js.context['myJsEdges'] = js.JsObject.jsify(outDagreEdges.map((edge) {
      return edge.toJson();
    }).toList());

    js.context['myJsRankdir'] = rd.name;
    js.context['myJsNodesep'] = slider1;
    js.context['myJsRanksep'] = slider2;
    js.context['myJsRanker'] = 'network-simplex';
  }

  void addDataset1(List<Node> outNodeList, List<DagreEdge> outDagreEdges) {
    outNodeList.add(Node(id: 'Z', width: 50, height: 50, label: 'Z'));
    outNodeList.add(Node(id: 'X', width: 150, height: 150, label: 'X'));
    outNodeList.add(Node(id: 'X0', width: 50, height: 50, label: 'X0'));
    outNodeList.add(Node(id: 'Y', width: 50, height: 50, label: 'Y'));
    outNodeList.add(Node(id: 'Y1', width: 50, height: 70, label: 'Y1'));
    outNodeList.add(Node(id: 'Y2', width: 50, height: 40, label: 'Y2'));
    outNodeList.add(Node(id: 'A', width: 25, height: 35, label: 'A'));
    outNodeList.add(Node(id: 'A1', width: 50, height: 50, label: 'A1'));
    outNodeList.add(Node(id: 'A2', width: 50, height: 50, label: 'A2'));
    outNodeList.add(Node(id: 'A3', width: 50, height: 50, label: 'A3'));
    outNodeList.add(Node(id: 'B', width: 120, height: 100, label: 'B'));
    outNodeList.add(Node(id: 'C', width: 50, height: 50, label: 'C'));
    outNodeList.add(Node(id: '1', width: 50, height: 150, label: '3'));
    outNodeList.add(Node(id: '2', width: 50, height: 50, label: '2'));
    outNodeList.add(Node(id: '3', width: 50, height: 50, label: '1'));
    outNodeList.add(Node(id: '4', width: 50, height: 50, label: '4'));
    outNodeList.add(Node(id: '41', width: 50, height: 50, label: '41'));
    outNodeList.add(Node(id: '42', width: 50, height: 50, label: '42'));

    outDagreEdges.add(DagreEdge(source: 'Z', target: 'X'));
    outDagreEdges.add(DagreEdge(source: 'X0', target: 'X'));
    outDagreEdges.add(DagreEdge(source: 'X', target: 'Y'));
    // outDagreEdges.add(DagreEdge(source: 'X', target: 'A', weight: 1));

    // outDagreEdges.add(DagreEdge(source: 'A', target: 'B', weight: 1));
    outDagreEdges.add(DagreEdge(source: 'A', target: 'A1'));
    outDagreEdges.add(DagreEdge(source: 'A', target: 'A2'));
    outDagreEdges.add(DagreEdge(source: 'A', target: 'A3'));
    outDagreEdges.add(DagreEdge(source: '2', target: 'A3'));

    outDagreEdges.add(DagreEdge(source: 'B', target: 'C'));
    outDagreEdges.add(DagreEdge(source: 'B', target: 'Y'));
    outDagreEdges.add(DagreEdge(source: 'B', target: '2'));
    outDagreEdges.add(DagreEdge(source: 'A', target: '4'));
    outDagreEdges.add(DagreEdge(source: '4', target: 'Z'));
    outDagreEdges.add(DagreEdge(source: 'Z', target: '1'));
    outDagreEdges.add(DagreEdge(source: 'Z', target: '3'));
    outDagreEdges.add(DagreEdge(source: 'Y', target: 'Y1'));
    outDagreEdges.add(DagreEdge(source: '4', target: '41'));
    outDagreEdges.add(DagreEdge(source: '4', target: '42'));
    outDagreEdges.add(DagreEdge(source: '41', target: 'X0'));
    outDagreEdges.add(DagreEdge(source: 'C', target: 'Y2'));
  }

  void addDataset2(List<Node> outNodeList, List<DagreEdge> outDagreEdges) {
    outNodeList.add(Node(id: 'A', width: 50, height: 50, label: 'A'));
    outNodeList.add(Node(id: 'B', width: 150, height: 150, label: 'B'));
    outNodeList.add(Node(id: 'C', width: 50, height: 50, label: 'C'));
    // d-h
    outNodeList.add(Node(id: 'D', width: 50, height: 50, label: 'D'));
    outNodeList.add(Node(id: 'E', width: 50, height: 50, label: 'E'));
    outNodeList.add(Node(id: 'F', width: 50, height: 50, label: 'F'));
    outNodeList.add(Node(id: 'G', width: 50, height: 50, label: 'G'));
    outNodeList.add(Node(id: 'H', width: 50, height: 50, label: 'H'));

    outDagreEdges.add(DagreEdge(source: 'E', target: 'B'));
  }

  void parse() {
    var jsonString = calculateLayout();

    Map<String, dynamic> result = jsonDecode(jsonString as String);

    nodes = result['nodes'];
    edges = result['edges'];
    graphSize = result['graph'];

    nodesList = nodes.entries
        .map((entry) => Node.fromJson(entry.key, entry.value))
        .toList();

    edgesList = edges.entries
        .map((entry) => EdgeData.fromJson(entry.key, entry.value))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Positioned(
                  child: CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                    painter: GraphPainter(
                        nodesList: nodesList, edgesList: edgesList),
                  ),
                ),
                ...nodesList.map((node) {
                  return Positioned(
                    left: node.x!.toDouble() - (node.width / 2),
                    top: node.y!.toDouble() - (node.height / 2),
                    child: InkWell(
                      onTap: () {
                        print(node.label);

                        // add another node
                        setState(() {
                          addnode(node.id);
                        });
                      },
                      child: Container(
                        width: node.width.toDouble(),
                        height: node.height.toDouble(),
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            node.label,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                Positioned(
                  bottom: 0,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      color: Colors.grey,
                      child: Row(
                        children: [
                          const SizedBox(width: 20),

                          InkWell(
                              onTap: () {
                                setState(() {
                                  clear();
                                });
                              },
                              child: const Text("clear")),
                          const SizedBox(width: 20),

                          InkWell(
                              onTap: () {
                                setState(() {
                                  loadDataset1();
                                });
                              },
                              child: const Text("Dataset 1")),
                          const SizedBox(width: 20),

                          InkWell(
                              onTap: () {
                                setState(() {
                                  loadDataset2();
                                });
                              },
                              child: const Text("Dataset 2")),
                          const SizedBox(width: 20),

                          InkWell(
                            onTap: () {
                              var nextDirection = returnNextDirection(
                                  js.context['myJsRankdir']);
                              js.context['myJsRankdir'] = nextDirection.name;
                              setState(() {
                                parse();
                              });
                            },
                            child: Text(
                              "direction:" + js.context['myJsRankdir'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),

                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              var nextRanker =
                                  returnNextRanker(js.context['myJsRanker']);

                              js.context['myJsRanker'] = nextRanker;
                              setState(() {
                                parse();
                              });
                            },
                            child: Text(
                              'Ranker:' + js.context['myJsRanker'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),

                          const SizedBox(width: 20),

                          // slider 80-150

                          Slider(
                            value: slider1,
                            onChanged: (value) {
                              setState(() {
                                slider1 = value;
                                js.context['myJsNodesep'] = slider1;
                                parse();
                              });
                            },
                            min: 50,
                            max: 200,
                            divisions: 25,
                            label: slider1.round().toString(),
                          ),

                          const SizedBox(width: 20),

                          // slider 80-150

                          Slider(
                            value: slider2,
                            onChanged: (value) {
                              setState(() {
                                slider2 = value;
                                js.context['myJsRanksep'] = slider2;
                                parse();
                              });
                            },
                            min: 50,
                            max: 200,
                            divisions: 25,
                            label: slider2.round().toString(),
                          ),

                          const Spacer(),
                          Text(
                              "Graph size : ${graphSize['width']} x ${graphSize['height']}",
                              style: const TextStyle(color: Colors.white)),
                        ],
                      )),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------
// Custom painter class
// ---------------------

class GraphPainter extends CustomPainter {
  final List<Node> nodesList; // List of nodes
  final List<EdgeData> edgesList; // List of edges

  GraphPainter({required this.nodesList, required this.edgesList});

  @override
  void paint(Canvas canvas, Size size) {
    Paint nodePaint = Paint()..color = Colors.blue;
    Paint edgePaint = Paint()..color = Colors.black;
    Paint textPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    for (var edge in edgesList) {
      for (var i = 0; i < edge.points.length - 1; i++) {
        canvas.drawLine(
          Offset(
              edge.points[i]['x']!.toDouble(), edge.points[i]['y']!.toDouble()),
          Offset(edge.points[i + 1]['x']!.toDouble(),
              edge.points[i + 1]['y']!.toDouble()),
          edgePaint,
        );
      }
    }

    // for (var node in nodesList) {
    //   // Draw node
    //   canvas.drawRect(
    //     Rect.fromCenter(
    //       center: Offset(node.x!.toDouble(), node.y!.toDouble()),
    //       width: node.width,
    //       height: node.height,
    //     ),
    //     nodePaint,
    //   );
    //
    //   // Draw label
    //   final TextSpan span = TextSpan(
    //     text: node.label,
    //     style: const TextStyle(color: Colors.white, fontSize: 18.0),
    //   );
    //   final TextPainter tp = TextPainter(
    //     text: span,
    //     textAlign: TextAlign.center,
    //     textDirection: TextDirection.ltr,
    //   );
    //
    //   tp.layout();
    //   tp.paint(
    //     canvas,
    //     Offset(
    //       node.x!.toDouble() - tp.width / 2,
    //       node.y!.toDouble() - tp.height / 2 + 5,
    //     ),
    //   );
    // }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
