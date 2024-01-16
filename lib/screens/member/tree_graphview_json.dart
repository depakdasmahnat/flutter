import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';


class TreeViewPageFromJson extends StatefulWidget {
  @override
  _TreeViewPageFromJsonState createState() => _TreeViewPageFromJsonState();
}

class _TreeViewPageFromJsonState extends State<TreeViewPageFromJson> {
  var json = {
    'members': [
      {'id': 1, 'name': 'circle'},
      {'id': 2, 'name': 'ellipse'},
      {'id': 3, 'name': 'database'},
      {'id': 4, 'name': 'box'},
      {'id': 5, 'name': 'diamond'},
      {'id': 6, 'name': 'dot'},
      {'id': 7, 'name': 'square'},
      {'id': 8, 'name': 'triangle'},
    ],
    'edges': [
      {'from': 1, 'to': 2},
      {'from': 1, 'to': 3},
      {'from': 3, 'to': 7},
      {'from': 6, 'to': 8},
      {'from': 2, 'to': 4},
      {'from': 2, 'to': 5},
      {'from': 3, 'to': 6},
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Wrap(
              children: [
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    initialValue: builder.siblingSeparation.toString(),
                    decoration: const InputDecoration(labelText: 'Sibling Separation'),
                    onChanged: (text) {
                      builder.siblingSeparation = int.tryParse(text) ?? 100;
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    initialValue: builder.levelSeparation.toString(),
                    decoration: const InputDecoration(labelText: 'Level Separation'),
                    onChanged: (text) {
                      builder.levelSeparation = int.tryParse(text) ?? 100;
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    initialValue: builder.subtreeSeparation.toString(),
                    decoration: const InputDecoration(labelText: 'Subtree separation'),
                    onChanged: (text) {
                      builder.subtreeSeparation = int.tryParse(text) ?? 100;
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    initialValue: builder.orientation.toString(),
                    decoration: const InputDecoration(labelText: 'Orientation'),
                    onChanged: (text) {
                      builder.orientation = int.tryParse(text) ?? 100;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: InteractiveViewer(
                  constrained: false,
                  boundaryMargin: const EdgeInsets.all(100),
                  minScale: 0.01,
                  maxScale: 5.6,
                  child: GraphView(
                    graph: graph,
                    algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
                    paint: Paint()
                      ..color = Colors.green
                      ..strokeWidth = 1
                      ..style = PaintingStyle.stroke,
                    builder: (Node node) {
                      // I can decide what widget should be shown here based on the id
                      var a = node.key!.value as int?;
                      var members = json['members']!;
                      var nodeValue = members.firstWhere((element) => element['id'] == a);
                      return rectangleWidget(nodeValue['name'] as String?);
                    },
                  )),
            ),
          ],
        ));
  }

  Widget rectangleWidget(String? a) {
    return InkWell(
      onTap: () {
        print('clicked');
      },
      child: Column(
        children: [
          const CircleAvatar(),
          Text('${a}'),
        ],
      ),
    );
  }

  final Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  @override
  void initState() {
    super.initState();
    var edges = json['edges']!;
    edges.forEach((element) {
      var fromNodeId = element['from'];
      var toNodeId = element['to'];
      graph.addEdge(Node.Id(fromNodeId), Node.Id(toNodeId));
    });

    builder
      ..siblingSeparation = (50)
      ..levelSeparation = (50)
      ..subtreeSeparation = (100)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
  }
}
