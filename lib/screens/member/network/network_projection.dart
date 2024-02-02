import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphview/GraphView.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/models/dashboard/color_grades.dart';
import 'package:mrwebbeast/screens/member/network/downline_members.dart';
import 'package:mrwebbeast/utils/widgets/custom_bottom_sheet.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/network/network_controller.dart';
import '../../../core/constant/constant.dart';
import '../../../core/route/route_paths.dart';
import '../../../models/member/network/projection_view_model.dart';
import '../../../models/member/network/tree_graph_model.dart';
import '../../../utils/custom_menu_popup.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../home/member_profile_details.dart';

class NetworkProjection extends StatefulWidget {
  const NetworkProjection({super.key});

  @override
  NetworkProjectionState createState() => NetworkProjectionState();
}

class NetworkProjectionState extends State<NetworkProjection> {
  List<ColorGrades> colorGrades = [
    ColorGrades(gradient: redGradient, percentage: 20),
    ColorGrades(gradient: yellowGradient, percentage: 40),
    ColorGrades(gradient: greenGradient, percentage: 60),
    ColorGrades(gradient: skyBlueGradient, percentage: 80),
    ColorGrades(gradient: purpleGradient, percentage: 100),
  ];

  int currentUserLevel = 2;
  int maxLevel = 14;
  Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  List<ProjectionViewData>? projectionViewNodes;

  Future fetchTreeView({String? memberId}) async {
    projectionViewNodes = await context.read<NetworkControllers>().fetchProjectionView(memberId: memberId);
    if (projectionViewNodes.haveData) {
      debugPrint('treeGraph $projectionViewNodes');
      for (int index = 0; index < (projectionViewNodes?.length ?? 0); index++) {
        ProjectionViewData? element = projectionViewNodes?.elementAt(index);
        num? fromNodeId = element?.level;

        if (index == 0) {
          graph.addNode(Node.Id(fromNodeId));
          // graph.addEdge(Node.Id(fromNodeId), Node.Id(fromNodeId));
        }
        if (element?.connectedMember.haveData == true) {
          for (int index = 0; index < (element?.connectedMember?.length ?? 0); index++) {
            var connectedMember = element?.connectedMember?.elementAt(index);
            num? toNodeId = connectedMember?.id;
            graph.addEdge(Node.Id(fromNodeId), Node.Id(toNodeId));
          }
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchTreeView();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkControllers>(builder: (context, controller, child) {
      projectionViewNodes = controller.projectionViewNodes;
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
                if (controller.loadingProjectionView)
                  const Expanded(
                    child: LoadingScreen(
                      message: 'Loading Projection View',
                    ),
                  )
                else if (graph.nodes.haveData)
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
                          List<ProjectionViewData>? members = projectionViewNodes;
                          var filteredMembers = members?.where((element) => element.id == indexId).toList();
                          ProjectionViewData? data;

                          if (filteredMembers.haveData) {
                            data = filteredMembers?.first;
                          }

                          return rectangleWidget(data);
                        },
                      ),
                    ),
                  )
                else
                  const Expanded(
                    child: NoDataFound(
                      message: 'No Projection View Found',
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget rectangleWidget(ProjectionViewData? data) {
    return GestureDetector(
      onTap: () {
        CustomBottomSheet.show(
          title: 'Select Projection Member',
          centerTitle: true,
          showBackButton: true,
          borderRadius: 34,
          context: context,
          body: DownLineMembers(
            memberId: data?.id,
            level: data?.level,
            parentId: data?.parentId,
          ),
        );
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
                assetImage: '${data?.profilePic}',
              ),
            ),
          ),
          if (data?.name != null)
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 2),
              child: Text(
                '${data?.name}: (${data?.sales ?? '0'})',
                style: const TextStyle(fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
