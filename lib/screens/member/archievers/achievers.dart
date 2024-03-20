// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mrwebbeast/controllers/member/member_controller/member_controller.dart';
// import 'package:mrwebbeast/core/constant/gradients.dart';
// import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
// import 'package:mrwebbeast/screens/member/archievers/archievers_table.dart';
//
// import 'package:mrwebbeast/screens/member/archievers/top_achievers_banner.dart';
// import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
// import 'package:mrwebbeast/utils/widgets/custom_bottom_sheet.dart';
// import 'package:mrwebbeast/utils/widgets/custom_text_field.dart';
// import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
//
// import 'package:provider/provider.dart';
//
// import '../../../core/config/app_assets.dart';
// import '../../../core/constant/constant.dart';
// import '../../../models/member/dashboard/achievers_model.dart';
// import '../../../utils/custom_menu_popup.dart';
// import '../../../utils/widgets/image_view.dart';
// import '../../../utils/widgets/loading_screen.dart';
// import '../../../utils/widgets/no_data_found.dart';
// import '../../../utils/widgets/option_picker.dart';
//
// class Achievers extends StatefulWidget {
//   const Achievers({super.key});
//
//   @override
//   State<Achievers> createState() => _AchieversState();
// }
//
// class _AchieversState extends State<Achievers> {
//   List<AchieversData>? achievers;
//   List<AchieversData>? topListData;
//   TextEditingController searchController = TextEditingController();
//
//   String? rank;
//   Future fetchAchievers() async {
//     achievers = await context.read<MembersController>().fetchAchievers(
//           search: searchController.text,
//           filter: filter,
//           rank: selectedRank,
//         );
//   }
//   String? filter;
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       fetchAchievers();
//     });
//   }
//   Timer? _debounce;
//   void onSearchFieldChanged(String value) {
//     if (_debounce?.isActive ?? false) _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       fetchAchievers();
//       setState(() {});
//     });
//   }
//   String? selectedRank;
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MembersController>(builder: (context, controller, child) {
//       achievers = controller.achievers;
//       topListData = controller.topListData;
//       Size size = MediaQuery.sizeOf(context);
//       return Scaffold(
//         body: Column(
//           children: [
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.elliptical(200, 60),
//                 bottomRight: Radius.elliptical(200, 60),
//               ),
//               child: Container(
//                 // height: size.height * 0.3,
//                 decoration: BoxDecoration(gradient: primaryGradient),
//                 child: Stack(
//                   children: [
//                     const Positioned(
//                       left: 0,
//                       right: -14,
//                       bottom: -14,
//                       child: ImageView(
//                         assetImage: AppAssets.dashboardRings,
//                       ),
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                       children: [
//                         AppBar(
//                           leading: const CustomBackButton(),
//                           title: const Text(
//                             'Achievers',
//                             style: TextStyle(color: Colors.black),
//                           ),
//                           backgroundColor: Colors.transparent,
//                           elevation: 0,
//                         ),
//                         if (controller.loadingAchievers)
//                           const LoadingScreen(
//                             heightFactor: 0.2,
//                             message: 'Loading Top Achievers...',
//                           )
//                         else if (topListData != null)
//                           TopAchieversBanners(data: topListData)
//                         else
//                           const NoDataFound(
//                             heightFactor: 0.2,
//                             color: Colors.black,
//                             message: 'No Top Achievers Found',
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: kPadding),
//               child: Row(
//                 children: [
//                   Flexible(
//                     child: CustomTextField(
//                       hintText: 'Search',
//                       controller: searchController,
//                       hintStyle: const TextStyle(color: Colors.white),
//                       prefixIcon: ImageView(
//                         height: 20,
//                         width: 20,
//                         borderRadiusValue: 0,
//                         color: Colors.white,
//                         margin: const EdgeInsets.only(left: kPadding, right: kPadding),
//                         fit: BoxFit.contain,
//                         assetImage: AppAssets.searchIcon,
//                         onTap: () {
//                           fetchAchievers();
//                         },
//                       ),
//                       onChanged: (val) {
//                         onSearchFieldChanged(val);
//                       },
//                       onEditingComplete: () {
//                         fetchAchievers();
//                       },
//                       margin: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
//                     ),
//                   ),
//                   CustomPopupMenu(
//                     items: [
//                       CustomPopupMenuEntry(
//                         label: 'Rank',
//                         onPressed: () {
//                           CustomBottomSheet.show(
//                             context: context,
//                             title: 'Rank Filter',
//                             centerTitle: true,
//                             showBackButton: true,
//                             body: StatefulBuilder(builder: (context, setState) {
//                               return Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: kPadding),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     OptionPicker(
//                                       selected: selectedRank,
//                                       list: levels,
//                                       onChanged: (val) {
//                                         selectedRank = val;
//                                         setState(() {});
//                                         this.setState(() {});
//                                       },
//                                     ),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         GradientButton(
//                                           height: 45,
//                                           width: size.width * .42,
//                                           backgroundGradient: blackGradient,
//                                           onTap: () {
//                                             context.pop();
//                                           },
//                                           margin: const EdgeInsets.only(top: kPadding, left: kPadding),
//                                           child: const Center(
//                                             child: Text(
//                                               'Clear',
//                                               style: TextStyle(color: Colors.white),
//                                             ),
//                                           ),
//                                         ),
//                                         GradientButton(
//                                           height: 45,
//                                           width: size.width * .42,
//                                           backgroundGradient: primaryGradient,
//                                           onTap: () async {
//                                             setState(() {});
//                                             this.setState(() {});
//                                             context.pop();
//                                             await fetchAchievers();
//                                           },
//                                           margin: const EdgeInsets.only(top: kPadding, right: kPadding),
//                                           child: const Center(
//                                             child: Text(
//                                               'Apply',
//                                               style: TextStyle(color: Colors.black),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               );
//                             }),
//                           );
//                         },
//                       ),
//                     ],
//                     onChange: (String? val) {
//                       filter = val;
//                       setState(() {});
//                       fetchAchievers();
//                     },
//                     child: GradientButton(
//                       height: 60,
//                       width: 60,
//                       margin: const EdgeInsets.only(left: 8, right: kPadding, bottom: kPadding),
//                       backgroundGradient: blackGradient,
//                       child: const ImageView(
//                         height: 28,
//                         width: 28,
//                         assetImage: AppAssets.filterIcons,
//                         margin: EdgeInsets.zero,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             if (controller.loadingAchievers)
//               const Expanded(
//                 child: LoadingScreen(
//                   message: 'Loading Achievers View',
//                 ),
//               )
//             else if (achievers.haveData)
//               Expanded(
//                   child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: kPadding),
//                 child: AchieversTable(achievers: achievers),
//               ))
//             else
//               const Expanded(
//                 child: NoDataFound(
//                   message: 'No Achievers Found',
//                 ),
//               ),
//           ],
//         ),
//       );
//     });
//   }
// }
import 'dart:async';


import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mrwebbeast/controllers/member/member_controller/member_controller.dart';

import 'package:mrwebbeast/screens/guest/guest_check_demo/guest_check_demo_step2.dart';

import 'package:mrwebbeast/screens/member/archievers/top_achievers_banner.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';

import 'package:mrwebbeast/utils/widgets/gradient_button.dart';

import 'package:provider/provider.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../models/member/dashboard/achievers_model.dart';

import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';


class Achievers extends StatefulWidget {
  const Achievers({super.key});

  @override
  State<Achievers> createState() => _AchieversState();
}

class _AchieversState extends State<Achievers> {
  late ConfettiController _centerController;
  List<AchieversData>? achievers;
  List<AchieversData>? topListData;
  TextEditingController searchController = TextEditingController();

  String? rank;
  Future fetchAchievers() async {
    achievers = await context.read<MembersController>().fetchAchievers(
          search: searchController.text,
          filter: filter,
          rank: selectedRank,
        );
  }

  String? filter;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchAchievers();
      _centerController =
          ConfettiController(duration: const Duration(seconds: 10));
      _centerController.play();
    });
  }

  Timer? _debounce;
  void onSearchFieldChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchAchievers();
      setState(() {});
    });
  }
  @override
  void dispose() {

    _centerController.dispose();
    super.dispose();
  }

  String? selectedRank;
  @override
  Widget build(BuildContext context) {
    return Consumer<MembersController>(builder: (context, controller, child) {
      achievers = controller.achievers;
      topListData = controller.topListData;
      Size size = MediaQuery.sizeOf(context);
      return Scaffold(
        body: Stack(
          fit: StackFit.loose,
          children: [

            Image.asset(
              AppAssets.achiversBackgroudn,
              fit: BoxFit.fill,
              width: double.infinity,
            ),


            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [


                // const ImageView(
                //   height: 100,
                //   assetImage: AppAssets.confeti2,
                // ),
                AppBar(
                  leading: const CustomBackButton(),
                  title: const Text(
                    'Achievers',
                    style: TextStyle(color: Colors.black),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                // SizedBox(
                //   height: size.height*0.0,
                // ),
                const ImageView(
                  assetImage: AppAssets.congo,
                  fit: BoxFit.fill,
                  padding: EdgeInsets.all(0),
                ),
                const SizedBox(
                  height: 8,
                ),

                CustomText1(
                  text: 'GTP SUPERSTAR',
                  color: Colors.white,
                  fontSize: 40,
                  textHeight: 0.09,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                if (controller.loadingAchievers)
                  const LoadingScreen(
                    heightFactor: 0.2,
                    message: 'Loading Top Achievers...',
                  )
                else if (topListData != null)
                  TopAchieversBanners(data: topListData)
                else
                  const NoDataFound(
                    heightFactor: 0.2,
                    color: Colors.black,
                    message: 'No Top Achievers Found',
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: kPadding,right: kPadding),
                  child: GradientButton(
                    height: 70,
                    borderRadius: 20,

                    backgroundColor: Colors.black,
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       CustomText1(
                         text: '1st Rank of This Month',
                         color: Colors.white,
                          fontSize: 20,
                       )
                     ],
                   ),

                  ),
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}
