import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/screens/member/network/pinnacle_list_table.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
import 'package:mrwebbeast/utils/widgets/custom_text_field.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/network/network_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../models/member/network/pinnacle_list_model.dart';
import '../../../utils/custom_menu_popup.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';

class NetworkReport extends StatefulWidget {
  const NetworkReport({super.key});

  @override
  State<NetworkReport> createState() => _NetworkReportState();
}

class _NetworkReportState extends State<NetworkReport> {
  List<PinnacleListData>? pinnacleList;
  TextEditingController searchController = TextEditingController();

  Future fetchPinnacleList() async {
    pinnacleList = await context.read<NetworkControllers>().fetchNetworkReports(
          search: searchController.text,
          filter: filter,
        );
  }

  String? filter;

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
      pinnacleList = controller.networkReports;
      return Scaffold(
        appBar: AppBar(
          leading: const CustomBackButton(),
          title: const Text('Report'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: kPadding),
              child: Row(
                children: [
                  Flexible(
                    child: CustomTextField(
                      hintText: 'Search',
                      controller: searchController,
                      hintStyle: const TextStyle(color: Colors.white),
                      prefixIcon: ImageView(
                        height: 20,
                        width: 20,
                        borderRadiusValue: 0,
                        color: Colors.white,
                        margin: const EdgeInsets.only(left: kPadding, right: kPadding),
                        fit: BoxFit.contain,
                        assetImage: AppAssets.searchIcon,
                        onTap: () {
                          fetchPinnacleList();
                        },
                      ),
                      onEditingComplete: () {
                        fetchPinnacleList();
                      },
                      margin: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                    ),
                  ),
                  CustomPopupMenu(
                    items: [
                      CustomPopupMenuEntry(
                        value: '',
                        label: 'All',
                        onPressed: () {
                          filter = null;
                        },
                      ),
                      CustomPopupMenuEntry(
                        label: 'Level',
                        onPressed: null,
                      ),
                      CustomPopupMenuEntry(
                        label: 'Achievement',
                        onPressed: null,
                      ),
                      CustomPopupMenuEntry(
                        label: 'Conversion Ratio',
                        onPressed: null,
                      ),
                      CustomPopupMenuEntry(
                        label: 'Progress',
                        onPressed: null,
                      ),
                      CustomPopupMenuEntry(
                        label: 'Training',
                        onPressed: null,
                      ),
                      CustomPopupMenuEntry(
                        label: 'Demo',
                        onPressed: null,
                      ),
                      CustomPopupMenuEntry(
                        label: 'Target',
                        onPressed: null,
                      ),
                    ],
                    onChange: (String? val) {
                      filter = val;
                      setState(() {});
                      fetchPinnacleList();
                    },
                    child: GradientButton(
                      height: 60,
                      width: 60,
                      margin: const EdgeInsets.only(left: 8, right: kPadding,bottom: kPadding),
                      backgroundGradient: blackGradient,
                      child: const ImageView(
                        height: 28,
                        width: 28,
                        assetImage: AppAssets.filterIcons,
                        margin: EdgeInsets.zero,
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (controller.loadingNetworkReports)
              const Expanded(
                child: LoadingScreen(
                  message: 'Loading Report View',
                ),
              )
            else if (pinnacleList.haveData)
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding),
                child: NetworkPinnacleTable(
                  pinnacleList: pinnacleList,
                ),
              ))
            else
              const Expanded(
                child: NoDataFound(
                  message: 'No Report Found',
                ),
              ),
          ],
        ),
      );
    });
  }
}
