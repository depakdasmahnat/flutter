import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphview/GraphView.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/models/dashboard/color_grades.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:mrwebbeast/utils/widgets/no_data_found.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/network/network_controller.dart';
import '../../../core/constant/constant.dart';
import '../../../core/route/route_paths.dart';
import '../../../models/member/network/tree_graph_model.dart';
import '../../../utils/custom_menu_popup.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../home/member_profile_details.dart';

class NetworkTreeView extends StatefulWidget {
  const NetworkTreeView({super.key});

  @override
  NetworkTreeViewState createState() => NetworkTreeViewState();
}

class NetworkTreeViewState extends State<NetworkTreeView> {
  int currentUserLevel = 2;
  int maxLevel = 14;
  Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  List<TreeGraphData>? treeGraph;

  Future fetchTreeView() async {
    treeGraph = await context.read<NetworkControllers>().fetchTreeView();
    if (treeGraph.haveData) {
      debugPrint('treeGraph $treeGraph');

      for (int index = 0; index < (treeGraph?.length ?? 0); index++) {
        TreeGraphData? element = treeGraph?.elementAt(index);
        num? fromNodeId = element?.id;

        if (index == 0) {
          graph.addNode(Node.Id(fromNodeId));
          // graph.addEdge(Node.Id(fromNodeId), Node.Id(fromNodeId));
        }
        if (element?.connectedMember.haveData == true) {
          for (int index = 0; index < (element?.connectedMember?.length ?? 0); index++) {
            var connectedMember = element?.connectedMember?.elementAt(index);
            num? toNodeId = connectedMember;
            graph.addEdge(Node.Id(fromNodeId), Node.Id(toNodeId));
          }
        }
      }

      setState(() {});
      builder
        ..siblingSeparation = (35)
        ..levelSeparation = (35)
        ..subtreeSeparation = (35)
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
    return Consumer<NetworkControllers>(
      builder: (context, controller, child) {
        treeGraph = controller.networkTreeViewNodes;

        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Progress PH bar',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ClipRRect(
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
                ],
              ),
            ),
            if (controller.loadingTreeView)
              const Expanded(
                child: LoadingScreen(
                  message: 'Loading Tree View',
                ),
              )
            else if (treeGraph.haveData)
              Expanded(
                child: Row(
                  children: [
                    if (graph.nodes.haveData)
                      Expanded(
                        child: InteractiveViewer(
                          constrained: false,
                          boundaryMargin: const EdgeInsets.all(200),
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
                              List<TreeGraphData>? members = treeGraph;
                              var filteredMembers =
                                  members?.where((element) => element.id == indexId).toList();
                              TreeGraphData? data;

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
                  message: 'No Tree View Found',
                ),
              ),
          ],
        );
      },
    );
  }

  Widget rectangleWidget(TreeGraphData? data) {
    List<CustomPopupMenuEntry> widgets = [];
    if (data?.availableOptions.haveData == true) {
      data?.availableOptions?.forEach((element) {
        widgets.add(CustomPopupMenuEntry(
          label: 'Mark ${element.option}',
          onPressed: () async {
            await context
                .read<NetworkControllers>()
                .selectABMembers(context: context, memberId: data.id, memberType: '${element.option}');
          },
        ));
      });
    }

    widgets.add(
      CustomPopupMenuEntry(
        label: 'Check Profile',
        onPressed: () {
          context.pushNamed(Routs.memberProfileDetails, extra: MemberProfileDetails(memberId: '${data?.id}'));
        },
      ),
    );

    return CustomPopupMenu(
      items: widgets,
      onChange: (String? val) {},
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 2),
                decoration: BoxDecoration(
                  gradient: statusGradient(progress: data?.percentage),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: ImageView(
                    height: 32,
                    width: 32,
                    isAvatar: true,
                    borderRadiusValue: 40,
                    fit: BoxFit.cover,
                    border: Border.all(color: Colors.black, width: 2),
                    margin: const EdgeInsets.all(3),
                    networkImage: '${data?.profilePic}',
                  ),
                ),
              ),
              if (data?.section != null)
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
                        '${data?.section}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (data?.sales != null)
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 2),
              child: Text(
                '${data?.name} : ${data?.sales}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
