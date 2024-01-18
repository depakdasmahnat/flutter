import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/models/dashboard/color_grades.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';

import '../../../core/constant/constant.dart';
import '../../../models/dashboard/tree_graph_model.dart';

class NetworkTreeView extends StatefulWidget {
  const NetworkTreeView({super.key});

  @override
  NetworkTreeViewState createState() => NetworkTreeViewState();
}

class NetworkTreeViewState extends State<NetworkTreeView> {
  List<TreeGraphData> treeGraphData = [
    TreeGraphData(
      id: 1,
      profilePic: 'url',
      rank: 'A',
      level: '6A',
      sales: 45,
      percentage: 77,
      members: [2, 3],
    ),
    TreeGraphData(
      id: 2,
      profilePic: 'url',
      rank: 'A',
      level: '6A',
      sales: 15,
      percentage: 77,
      members: [4, 5],
    ),
    TreeGraphData(
      id: 3,
      profilePic: 'url',
      rank: 'B',
      level: '6A',
      sales: 72,
      percentage: 77,
      members: [6, 7],
    ),
    TreeGraphData(
      id: 4,
      profilePic: 'url',
      rank: 'C',
      level: '6A',
      sales: 23,
      percentage: 77,
      // connectedMember: [8, 9],
    ),
    TreeGraphData(
      id: 5,
      profilePic: 'url',
      rank: 'D',
      level: '6A',
      sales: 14,
      percentage: 77,
      // connectedMember: [10, 11],
    ),
    TreeGraphData(
      id: 6,
      profilePic: 'url',
      rank: 'E',
      level: '6A',
      sales: 19,
      percentage: 77,
      // connectedMember: [12, 13],
    ),
    TreeGraphData(
      id: 7,
      profilePic: 'url',
      rank: 'F',
      level: '6A',
      sales: 16,
      percentage: 77,
      // connectedMember: [14, 15],
    ),
  ];

  List<TreeGraphData> createTreeGraphData() {
    List<TreeGraphData> treeGraphData = [];

    // Create root node
    treeGraphData.add(TreeGraphData(
      id: 1,
      profilePic: 'url',
      rank: 'A',
      level: '1',
      sales: 55,
      percentage: 77,
      members: [2, 3],
    ));

    // Create remaining nodes
    int currentId = 2;
    for (int currentLevel = 2; currentLevel <= 14; currentLevel++) {
      int nodesAtCurrentLevel = pow(2, currentLevel - 1).toInt();
      for (int i = 0; i < nodesAtCurrentLevel; i++) {
        treeGraphData.add(TreeGraphData(
          id: currentId,
          profilePic: 'url',
          rank: 'A',
          // You can adjust the rank as needed
          level: currentLevel.toString(),
          sales: 55,
          percentage: 77,
          members: [currentId * 2, currentId * 2 + 1],
        ));
        currentId++;
      }
    }

    return treeGraphData;
  }

  List<ColorGrades> colorGrades = [
    ColorGrades(gradient: redGradient, percentage: 20),
    ColorGrades(gradient: yellowGradient, percentage: 40),
    ColorGrades(gradient: greenGradient, percentage: 60),
    ColorGrades(gradient: skyBlueGradient, percentage: 80),
    ColorGrades(gradient: purpleGradient, percentage: 100),
  ];

  int currentUserLevel = 2;
  int maxLevel = 14;

  final Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  @override
  void initState() {
    super.initState();

    List<TreeGraphData> treeGraph = treeGraphData;
    for (var element in treeGraph) {
      num? fromNodeId = element.id;
      if (element.members.haveData) {
        element.members?.forEach((element) {
          num? toNodeId = element;
          graph.addEdge(Node.Id(fromNodeId), Node.Id(toNodeId));
        });
      }
    }

    builder
      ..siblingSeparation = (50)
      ..levelSeparation = (50)
      ..subtreeSeparation = (100)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // treeGraphData = createTreeGraphData();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: colorGrades.map(
                (e) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: e.gradient,
                        ),
                        child: Flexible(
                          child: Center(
                            child: Text(
                              '${e.percentage}%',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding, bottom: 100),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 50,
                    child: ListView.builder(
                      itemCount: maxLevel,
                      itemBuilder: (BuildContext context, int index) {
                        bool currentLevel = currentUserLevel == (index + 1);

                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: currentLevel ? primaryGradient : whiteGradient,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Text(
                                  'Level',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InteractiveViewer(
                  constrained: false,
                  boundaryMargin: const EdgeInsets.all(100),
                  minScale: 0.01,
                  maxScale: 6,
                  child: GraphView(
                    graph: graph,
                    algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
                    paint: Paint()
                      ..color = Colors.white
                      ..strokeWidth = 1
                      ..style = PaintingStyle.stroke,
                    builder: (Node node) {
                      var indexId = node.key?.value as int?;
                      List<TreeGraphData> members = treeGraphData;
                      var filteredMembers = members.where((element) => element.id == indexId).toList();
                      TreeGraphData? data;

                      if (filteredMembers.haveData) {
                        data = filteredMembers.first;
                      }
                      return rectangleWidget(data);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget rectangleWidget(TreeGraphData? data) {
    return InkWell(
      onTap: () {
        print('clicked');
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              gradient: primaryGradient,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: ImageView(
                height: 30,
                width: 30,
                isAvatar: true,
                borderRadiusValue: 40,
                border: Border.all(color: Colors.black, width: 2),
                margin: const EdgeInsets.all(3),
                assetImage: 'AppAssets.appIcon',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: Text(
              'Sales: ${data?.sales}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
