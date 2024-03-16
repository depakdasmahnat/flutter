import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';

import 'package:mrwebbeast/screens/member/services/services_table.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
import 'package:mrwebbeast/utils/widgets/custom_text_field.dart';

import 'package:provider/provider.dart';

import '../../../controllers/member/network/network_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';

import '../../../models/member/services/services_model.dart';

import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<ServicesData>? serviceReports;

  TextEditingController searchController = TextEditingController();

  Future fetchServiceReports() async {
    serviceReports = await context.read<NetworkControllers>().fetchServiceReports(
          search: searchController.text,
          filter: filter,
        );
  }

  String? filter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchServiceReports();
    });
  }

  Timer? _debounce;

  void onSearchFieldChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchServiceReports();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkControllers>(builder: (context, controller, child) {
      serviceReports = controller.serviceReports;
      return Scaffold(
        appBar: AppBar(
          leading: const CustomBackButton(),
          title: const Text('Services'),
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
                          fetchServiceReports();
                        },
                      ),
                      onChanged: (val) async {
                        onSearchFieldChanged(val);
                      },
                      onEditingComplete: () {
                        fetchServiceReports();
                      },
                      margin: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                    ),
                  ),
                  // CustomPopupMenu(
                  //   items: [
                  //     CustomPopupMenuEntry(
                  //       value: '',
                  //       label: 'All',
                  //       onPressed: () {
                  //         filter = null;
                  //       },
                  //     ),
                  //     CustomPopupMenuEntry(
                  //       label: 'City',
                  //       onPressed: null,
                  //     ),
                  //     CustomPopupMenuEntry(
                  //       label: 'Name',
                  //       onPressed: null,
                  //     ),
                  //     CustomPopupMenuEntry(
                  //       label: 'Number',
                  //       onPressed: null,
                  //     ),
                  //     CustomPopupMenuEntry(
                  //       label: 'Number 2',
                  //       onPressed: null,
                  //     ),
                  //   ],
                  //   onChange: (String? val) {
                  //     filter = val;
                  //     setState(() {});
                  //     fetchServiceReports();
                  //   },
                  //   child: GradientButton(
                  //     height: 60,
                  //     width: 60,
                  //     margin: const EdgeInsets.only(left: 8, right: kPadding, bottom: kPadding),
                  //     backgroundGradient: blackGradient,
                  //     child: const ImageView(
                  //       height: 28,
                  //       width: 28,
                  //       assetImage: AppAssets.filterIcons,
                  //       margin: EdgeInsets.zero,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            if (controller.loadingServiceReports)
              const Expanded(
                child: LoadingScreen(
                  message: 'Loading Service View',
                ),
              )
            else if (serviceReports.haveData)
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding),
                child: ServicesTable(
                  pinnacleList: serviceReports,
                ),
              ))
            else
              const Expanded(
                child: NoDataFound(
                  message: 'No Service Found',
                ),
              ),
          ],
        ),
      );
    });
  }
}
