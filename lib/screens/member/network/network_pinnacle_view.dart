import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphview/GraphView.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';

import 'package:mrwebbeast/screens/member/home/member_profile_details.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:mrwebbeast/utils/widgets/no_data_found.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/network/network_controller.dart';
import '../../../core/constant/constant.dart';
import '../../../core/route/route_paths.dart';
import '../../../models/member/network/pinnacle_view_model.dart';
import '../../../utils/custom_menu_popup.dart';
import '../../../utils/widgets/gradient_button.dart';

class NetworkPinnacleView extends StatefulWidget {
  const NetworkPinnacleView({super.key});

  @override
  NetworkPinnacleViewState createState() => NetworkPinnacleViewState();
}

class NetworkPinnacleViewState extends State<NetworkPinnacleView> {
  int? currentUserLevel;

  int maxLevel = 14;
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
    Size size = MediaQuery.sizeOf(context);
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
                                onTap: () {
                                  currentUserLevel = (index + 1);
                                  controller.levelWiseMemberCount(level: currentUserLevel);
                                },
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
                                      if (currentLevel &&
                                          controller.levelWiseMemberCountModel?.remainingMembers != null)
                                        Column(
                                          children: [
                                            Text(
                                              '${controller.levelWiseMemberCountModel?.remainingMembers}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const Text(
                                              'Pending',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
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
                    if (graph.nodes.haveData)
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: InteractiveViewer(
                            constrained: false,
                            boundaryMargin:
                            EdgeInsets.only(left: 36, right: 36,top: 24, bottom: size.height * 0.25),
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
    return CustomPopupMenu(
      items: [
        CustomPopupMenuEntry(
          label: 'Check Profile',
          onPressed: () {
            context.pushNamed(Routs.memberProfileDetails,
                extra: MemberProfileDetails(
                  memberId: '${data?.id}',
                ));
          },
        ),
      ],
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
                  left: 0,
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
              if (data?.rank != null)
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
                        '${data?.rank}',
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
                'Sales: ${data?.sales ?? '0'}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
