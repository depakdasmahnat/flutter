import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/screens/member/network/pinnacle_list_table.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/network/network_controller.dart';
import '../../../core/constant/constant.dart';
import '../../../core/route/route_paths.dart';
import '../../../models/member/network/pinnacle_list_model.dart';
import '../../../models/member/network/tree_graph_model.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';

class NetworkPinnacleList extends StatefulWidget {
  const NetworkPinnacleList({super.key});

  @override
  NetworkPinnacleListState createState() => NetworkPinnacleListState();
}

class NetworkPinnacleListState extends State<NetworkPinnacleList> {
  int currentUserLevel = 2;
  int maxLevel = 14;

  List<PinnacleListData>? pinnacleList;

  Future fetchPinnacleList() async {
    pinnacleList = await context.read<NetworkControllers>().fetchPinnacleList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchPinnacleList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkControllers>(builder: (context, controller, child) {
      pinnacleList = controller.pinnacleList;
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only( bottom: kPadding),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  itemCount: maxLevel,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    bool currentLevel = currentUserLevel == (index + 1);

                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 45,
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
                                fontSize: 10,
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
          if (controller.loadingPinnacleList)
            const Expanded(
              child: LoadingScreen(
                message: 'Loading Pinnacle View',
              ),
            )
          else if (pinnacleList.haveData)
            Expanded(
                child: NetworkPinnacleTable(
              pinnacleList: pinnacleList,
            ))
          else
            const Expanded(
              child: NoDataFound(
                message: 'No Pinnacle View Found',
              ),
            ),
        ],
      );
    });
  }

  Widget rectangleWidget(TreeGraphData? data) {
    return InkWell(
      onTap: () {
        context.pushNamed(Routs.memberProfileDetails);
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              gradient: statusGradient(progress: data?.percentage),
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
