import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphview/GraphView.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/models/dashboard/color_grades.dart';
<<<<<<< HEAD
import 'package:mrwebbeast/screens/member/home/member_profile_details.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:mrwebbeast/utils/widgets/no_data_found.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/network/network_controller.dart';
import '../../../core/constant/constant.dart';
import '../../../core/route/route_paths.dart';
import '../../../models/member/network/pinnacle_view_model.dart';
import '../../../models/member/network/tree_graph_model.dart';
import '../../../utils/widgets/gradient_button.dart';
=======
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';

import '../../../core/constant/constant.dart';
import '../../../core/route/route_paths.dart';
import '../../../models/dashboard/tree_graph_model.dart';
>>>>>>> guestUI

class NetworkPinnacleView extends StatefulWidget {
  const NetworkPinnacleView({super.key});

  @override
  NetworkPinnacleViewState createState() => NetworkPinnacleViewState();
}

class NetworkPinnacleViewState extends State<NetworkPinnacleView> {
<<<<<<< HEAD
=======
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

>>>>>>> guestUI
  List<ColorGrades> colorGrades = [
    ColorGrades(gradient: redGradient, percentage: 20),
    ColorGrades(gradient: yellowGradient, percentage: 40),
    ColorGrades(gradient: greenGradient, percentage: 60),
    ColorGrades(gradient: skyBlueGradient, percentage: 80),
    ColorGrades(gradient: purpleGradient, percentage: 100),
  ];

  int currentUserLevel = 2;
  int maxLevel = 14;
<<<<<<< HEAD
  Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  List<PinnacleViewData>? treeGraph;

  Future fetchTreeView() async {
    treeGraph = await context.read<NetworkControllers>().fetchPinnacleView();
    if (treeGraph.haveData) {
      debugPrint('treeGraph $treeGraph');

      for (int index = 0; index < (treeGraph?.length ?? 0); index++) {
        PinnacleViewData? element = treeGraph?.elementAt(index);
        num? fromNodeId = element?.id;
        if (index == 0) {
          graph.addNode(Node.Id(fromNodeId));
        }
        if (element?.connectedMember.haveData == true) {
          element?.connectedMember?.forEach((element) {
            num? toNodeId = element.id;
            graph.addEdge(Node.Id(fromNodeId), Node.Id(toNodeId));
          });
        }
      }

      setState(() {});
      builder
        ..siblingSeparation = (50)
        ..levelSeparation = (50)
        ..subtreeSeparation = (100)
        ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
      setState(() {});
    }
  }
=======

  final Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
>>>>>>> guestUI

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchTreeView();
=======

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
>>>>>>> guestUI
    });
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Consumer<NetworkControllers>(
      builder: (context, controller, child) {
        treeGraph = controller.pinnacleViewNodes;

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
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            if (controller.loadingPinnacleView)
              const Expanded(
                child: LoadingScreen(
                  message: 'Loading Pinnacle View',
                ),
              )
            else if (treeGraph.haveData)
              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding, bottom: 100),
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
=======
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
                        child: Center(
                          child: Text(
                            '${e.percentage}%',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
>>>>>>> guestUI
                          ),
                        ),
                      ),
                    ),
<<<<<<< HEAD
                    if (graph.nodes.haveData)
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
                              List<PinnacleViewData>? members = treeGraph;
                              var filteredMembers =
                                  members?.where((element) => element.id == indexId).toList();
                              PinnacleViewData? data;

                              if (filteredMembers.haveData) {
                                data = filteredMembers?.first;
                              }

                              return rectangleWidget(data);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              )
            else
              const Expanded(
                child: NoDataFound(
                  message: 'No Pinnacle View Found',
                ),
              ),
          ],
        );
      },
    );
  }

  Widget rectangleWidget(PinnacleViewData? data) {
    return InkWell(
      onTap: () {
        context.pushNamed(Routs.memberProfileDetails, extra: const MemberProfileDetails());
=======
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
                padding: const EdgeInsets.only(
                    left: kPadding,
                    right: kPadding,
                    top: kPadding,
                    bottom: 100),
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
                              gradient: currentLevel
                                  ? primaryGradient
                                  : whiteGradient,
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
                    algorithm: BuchheimWalkerAlgorithm(
                        builder, TreeEdgeRenderer(builder)),
                    paint: Paint()
                      ..color = Colors.white
                      ..strokeWidth = 1
                      ..style = PaintingStyle.stroke,
                    builder: (Node node) {
                      var indexId = node.key?.value as int?;
                      List<TreeGraphData> members = treeGraphData;
                      var filteredMembers = members
                          .where((element) => element.id == indexId)
                          .toList();
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
        context.pushNamed(Routs.memberProfileDetails);
>>>>>>> guestUI
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 2),
                decoration: BoxDecoration(
<<<<<<< HEAD
                  gradient: statusGradient(sale: data?.sales),
=======
                  gradient: statusGradient(sales: data?.sales),
>>>>>>> guestUI
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: ImageView(
                    height: 38,
                    width: 38,
                    isAvatar: true,
                    borderRadiusValue: 40,
                    border: Border.all(color: Colors.black, width: 2),
                    margin: const EdgeInsets.all(3),
<<<<<<< HEAD
                    networkImage: '${data?.profilePic}',
                  ),
                ),
              ),
              if (data?.rank != null)
                Positioned(
                  top: 0,
                  left: 0,
                  child: GradientButton(
                    height: 14,
                    width: 14,
                    backgroundGradient: primaryGradient,
                    padding: EdgeInsets.zero,
                    child: Center(
                      child: Text(
                        '${data?.rank}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                        ),
=======
                    assetImage: 'AppAssets.appIcon',
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: GradientButton(
                  height: 14,
                  width: 14,
                  backgroundGradient: primaryGradient,
                  padding: EdgeInsets.zero,
                  child: Center(
                    child: Text(
                      '${data?.rank}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
>>>>>>> guestUI
                      ),
                    ),
                  ),
                ),
<<<<<<< HEAD
              if (data?.level != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: GradientButton(
                    height: 14,
                    width: 14,
                    backgroundGradient: primaryGradient,
                    padding: EdgeInsets.zero,
                    child: Center(
                      child: Text(
                        '${data?.level}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                        ),
=======
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GradientButton(
                  height: 14,
                  width: 14,
                  backgroundGradient: primaryGradient,
                  padding: EdgeInsets.zero,
                  child: Center(
                    child: Text(
                      '${data?.level}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
>>>>>>> guestUI
                      ),
                    ),
                  ),
                ),
<<<<<<< HEAD
            ],
          ),
          if (data?.sales != null)
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 2),
              child: Text(
                'Sales: ${data?.sales}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
=======
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: Text(
              'Sales: ${data?.sales}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
>>>>>>> guestUI
        ],
      ),
    );
  }
}
