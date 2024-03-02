import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/controllers/member/member_controller/member_controller.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:mrwebbeast/utils/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../controllers/member/member_controller/demo_controller.dart';
import '../../../core/constant/constant.dart';
import '../../../core/constant/gradients.dart';
import '../../../models/feeds/feeds_data.dart';
import '../../../models/member/demo/demo_model.dart';
import '../../../utils/custom_menu_popup.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/image_view.dart';
import '../../guest/guestProfile/guest_faq.dart';
import '../../member/feeds/feeds_card.dart';

class DemosScreen extends StatefulWidget {
  const DemosScreen({super.key});

  @override
  State<DemosScreen> createState() => _DemosScreenState();
}

class _DemosScreenState extends State<DemosScreen> {
  List<DemosData>? demos;
  String? filter;
  Future fetchDemos({bool? loadingNext}) async {
    return await context.read<DemoController>().fetchDemos(
          context: context,
          isRefresh: loadingNext == true ? false : true,
          loadingNext: loadingNext ?? false,
          searchKey: searchController.text,
          filter: filter,
      type:  true
        );
  }
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchDemos();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
      ),
      body: Consumer<DemoController>(
        builder: (context, controller, child) {
          demos = controller.demos;
          return SmartRefresher(
            controller: controller.demosController,
            enablePullUp: true,
            enablePullDown: true,
            onRefresh: () async {
              if (mounted) {
                await fetchDemos();
              }
            },
            onLoading: () async {
              if (mounted) {
                await fetchDemos(loadingNext: true);
              }
            },
            child: ListView(
              shrinkWrap: true,
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
                              fetchDemos();
                            },
                          ),
                          onEditingComplete: () {
                            fetchDemos();
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
                          fetchDemos();
                        },
                        child: GradientButton(
                          height: 60,
                          width: 60,
                          margin: const EdgeInsets.only(left: 8, right: kPadding, bottom: kPadding),
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
                controller.loadingDemos == true
                    ? const LoadingScreen(heightFactor: 0.7)
                    : (demos.haveData)
                        ? ListView.builder(
                            itemCount: demos?.length ?? 0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: kPadding),
                            // physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var data = demos?.elementAt(index);
                              return InkWell(
                                onTap: () {
                                  // if(widget.type!='true'){
                                  //   context.pushNamed(Routs.resourceAndDemo,extra:true );
                                  // }
                                },
                                child: DemoCard(
                                  tabIndex: index,
                                  data: data,
                                ),
                              );
                            },
                          )
                        : const NoDataFound(heightFactor: 0.7),
              ],
            ),
          );
        },
      ),
      // bottomNavigationBar: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     GradientButton(
      //       height: 60,
      //       borderRadius: 18,
      //       backgroundGradient: primaryGradient,
      //       blur: 20,
      //       backgroundColor: Colors.transparent,
      //       boxShadow: const [],
      //       margin: const EdgeInsets.only(left: 16, right: 24, bottom: 24),
      //       onTap: () {
      //         context.pushNamed(Routs.createDemo);
      //       },
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Text(
      //             'Create a Demo',
      //             style: TextStyle(
      //               color: Colors.black,
      //               fontFamily: GoogleFonts.urbanist().fontFamily,
      //               fontWeight: FontWeight.w600,
      //               fontSize: 18,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class DemoCard extends StatelessWidget {
  final int? tabIndex;
  final DemosData? data;

  const DemoCard({
    this.tabIndex,
    this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: decoration,
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              ImageView(
                height: 24,
                width: 24,
                isAvatar: true,
                borderRadiusValue: 40,
                networkImage: '${data?.profilePhoto}',
                margin: const EdgeInsets.only(right: 8),
              ),
              CustomeText(
                text: data?.firstName ?? '',
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          CustomeText(
            text: data?.demoDate ?? '',
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          CustomeText(
            text: data?.demoTime ?? '',
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          CustomeText(
            text: data?.demoType ?? '',
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          GradientButton(
            height: 22,
            padding: const EdgeInsets.symmetric(horizontal: kPadding),
            backgroundGradient: primaryGradient,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data?.demoType ?? '',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
