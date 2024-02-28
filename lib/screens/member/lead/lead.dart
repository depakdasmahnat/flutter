import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/utils/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import '../../../controllers/member/leads/leads_controllers.dart';
import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../core/route/route_paths.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/custom_bottom_sheet.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';
import '../../dashboard/more_menu.dart';
import '../../guest/guestProfile/guest_faq.dart';
import '../demo/create_demo.dart';
import '../home/member_profile_details.dart';
import '../profile/profile.dart';
import 'custom_popup_menu.dart';

import 'leads_popup.dart';
import 'model_dailog_box.dart';

class Lead extends StatefulWidget {
  const Lead({super.key});

  @override
  State<Lead> createState() => _LeadState();
}

class _LeadState extends State<Lead> {
  int tabIndex = 0;

  List tabItem = [
    'Newly Listed',
    'Invitation Call',
    'Demo Scheduled',
    'Follow Up',
    'Closed'
  ];
  List item = [
    {
      'image': '08',
      'first': 'Added to\nlist',
      'second': 'Getting Started',
      'gradiant': primaryGradient,
      'color': const Color(0xFFE1FF41),
    },
    {
      'image': '02',
      'first': 'Demo\nScheduled',
      'second': 'How to Invest',
      'gradiant': null,
      'color': const Color(0xFFE1FF41),
    },
    {
      'image': '04',
      'first': 'Demo\nScheduled',
      'second': 'Payment Meth…',
      'gradiant': null,
      'color': Colors.white,
    },
    {
      'image': '04',
      'first': 'Leads\nClosed',
      'second': 'Payment Meth…',
      'gradiant': null,
      'color': Colors.white,
    }
  ];

  // bool showItem =false;
  String status = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<MembersController>().fetchLeads(status: 'New', priority: '', page: '1');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<MembersController>(
      builder: (context, controller, child) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: controller.leadsLoader == false
                ? PreferredSize(
                    preferredSize: Size.fromHeight(size.height * 0.54),
                    child: const Center(
                      child: CupertinoActivityIndicator(
                          radius: 15, color: CupertinoColors.white),
                    ),
                  )
                : PreferredSize(
                    preferredSize: Size.fromHeight(size.height * 0.4),
                    child: CustomAppBar(
                      showLeadICon: false,
                      title: 'List',
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(size.height * 0.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: size.width * 0.15,
                              width: double.infinity,
                              clipBehavior: Clip.antiAlias,
                              decoration: const ShapeDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.00, -1.00),
                                  end: Alignment(0, 1),
                                  colors: [
                                    Color(0xFF3B3B3B),
                                    Color(0xFF4A4A4A)
                                  ],
                                ),
                                shape: RoundedRectangleBorder(

                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                ),
                              ),
                              child: ListView.builder(
                                itemCount: tabItem.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () async {
                                        tabIndex = index;
                                        status = tabItem[index];
                                        if (status == 'Newly Listed') {
                                          status = 'New';
                                        }
                                        setState(() {});
                                        await context
                                            .read<MembersController>()
                                            .fetchLeads(
                                                status: status,
                                                priority: '',
                                                page: '1');
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: size.width * 0.3,
                                          height: size.width * 0.06,
                                          decoration: ShapeDecoration(
                                            gradient: index == tabIndex
                                                ? primaryGradient
                                                : inActiveGradient,
                                            shape:  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(13))
                                              // borderRadius: BorderRadius.only(
                                              //     topRight:
                                              //         Radius.circular(100),
                                              //     bottomRight:
                                              //         Radius.circular(100)),
                                            ),
                                          ),
                                          child: Center(
                                              child: CustomeText(
                                            text: tabItem[index],
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: index == tabIndex
                                                ? Colors.black
                                                : Colors.white,
                                          )),
                                        ),
                                      ));
//                             Padding(
//                               padding: const EdgeInsets.only(left: kPadding, top: 8),
//                               child: SizedBox(
//                                   height: size.height * 0.12,
//                                   child: Align(
//                                     alignment: Alignment.topCenter,
//                                     child: ListView(
//                                       scrollDirection: Axis.horizontal,
//                                       physics: const NeverScrollableScrollPhysics(),
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(3),
//                                           child: Container(
//                                             width: size.width * 0.22,
//                                             decoration: ShapeDecoration(
//                                               gradient: primaryGradient,
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.circular(18),
//                                               ),
//                                             ),
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(left: 8.0, top: 6, bottom: 6),
//                                               child: Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 mainAxisAlignment: MainAxisAlignment.center,
//                                                 children: [
//                                                   CustomeText(
//                                                     text: '${controller.fetchLeadsModel?.stats?.new1}',
//                                                     fontSize: 28,
//                                                     fontWeight: FontWeight.w700,
//                                                     color: Colors.black,
//                                                   ),
//                                                   const Text(
//                                                     'Added\nto list',
//                                                     style: TextStyle(
//                                                       color: Colors.black,
//                                                       fontSize: 13,
//                                                       fontWeight: FontWeight.w600,
//                                                     ),
//                                                     textAlign: TextAlign.start,
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.all(3),
//                                           child: Container(
//                                             width: size.width * 0.22,
//                                             decoration: ShapeDecoration(
//                                               gradient: const LinearGradient(
//                                                   colors: [Color(0xFFF3F3F3), Color(0xFFE0E0E0)]),
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.circular(18),
//                                               ),
//                                             ),
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
//                                               child: Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 mainAxisAlignment: MainAxisAlignment.center,
//                                                 children: [
//                                                   CustomeText(
//                                                     text:
//                                                         '${controller.fetchLeadsModel?.stats?.invitationCall}',
//                                                     fontSize: 28,
//                                                     fontWeight: FontWeight.w700,
//                                                     color: Colors.black,
//                                                   ),
//                                                   const Text(
//                                                     'Demo\nScheduled',
//                                                     style: TextStyle(
//                                                       color: Colors.black,
//                                                       fontSize: 13,
//                                                       fontWeight: FontWeight.w600,
//                                                     ),
//                                                     textAlign: TextAlign.start,
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.all(3),
//                                           child: Container(
//                                             width: size.width * 0.22,
//                                             decoration: ShapeDecoration(
//                                               gradient: const LinearGradient(
//                                                   colors: [Color(0xFFF3F3F3), Color(0xFFE0E0E0)]),
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.circular(18),
//                                               ),
//                                             ),
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
//                                               child: Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 mainAxisAlignment: MainAxisAlignment.center,
//                                                 children: [
//                                                   CustomeText(
//                                                     text: '${controller.fetchLeadsModel?.stats?.followup}',
//                                                     fontSize: 28,
//                                                     fontWeight: FontWeight.w700,
//                                                     color: Colors.black,
//                                                   ),
//                                                   const Text(
//                                                     'Demo\nDone',
//                                                     style: TextStyle(
//                                                       color: Colors.black,
//                                                       fontSize: 13,
//                                                       fontWeight: FontWeight.w600,
//                                                     ),
//                                                     textAlign: TextAlign.start,
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.all(3),
//                                           child: Container(
//                                             width: size.width * 0.22,
//                                             decoration: ShapeDecoration(
//                                               gradient: const LinearGradient(
//                                                   colors: [Color(0xFF3B3B3B), Color(0xFF4A4A4A)]),
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.circular(18),
//                                               ),
//                                             ),
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
//                                               child: Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 mainAxisAlignment: MainAxisAlignment.center,
//                                                 children: [
//                                                   CustomeText(
//                                                     text: '${controller.fetchLeadsModel?.stats?.closed}',
//                                                     fontSize: 28,
//                                                     fontWeight: FontWeight.w700,
//                                                     color: Colors.white,
//                                                   ),
//                                                   const Text(
//                                                     'Leads\nClosed',
//                                                     style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 13,
//                                                       fontWeight: FontWeight.w600,
//                                                     ),
//                                                     textAlign: TextAlign.start,
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
// >>>>>>> c7b688cbb475634220be72aa40dfb28e3eb7677f
//                                     ),
//                                   );
                                },
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: kPadding, top: 8),
                            //   child: SizedBox(
                            //       height: size.height * 0.11,
                            //       child: Align(
                            //         alignment: Alignment.topCenter,
                            //         child: ListView(
                            //           scrollDirection: Axis.horizontal,
                            //
                            //           children: [
                            //             Padding(
                            //               padding: const EdgeInsets.all(3),
                            //               child: Container(
                            //                 width: size.width * 0.22,
                            //                 decoration: ShapeDecoration(
                            //                   gradient: primaryGradient,
                            //                   shape: RoundedRectangleBorder(
                            //                     borderRadius: BorderRadius.circular(18),
                            //                   ),
                            //                 ),
                            //                 child: Padding(
                            //                   padding: const EdgeInsets.only(left: 8.0, top: 4, bottom: 4),
                            //                   child: Column(
                            //                     crossAxisAlignment: CrossAxisAlignment.start,
                            //                     mainAxisSize: MainAxisSize.min,
                            //                     mainAxisAlignment: MainAxisAlignment.center,
                            //                     children: [
                            //                       CustomeText(
                            //                         text: '${controller.fetchLeadsModel?.stats?.new1}',
                            //                         fontSize: 28,
                            //                         fontWeight: FontWeight.w700,
                            //                         color: Colors.black,
                            //                       ),
                            //                       const Text(
                            //                         'Added\nto list',
                            //                         style: TextStyle(
                            //                           color: Colors.black,
                            //                           fontSize: 12,
                            //                           fontWeight: FontWeight.w600,
                            //                         ),
                            //                         textAlign: TextAlign.start,
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 ),
                            //               ),
                            //             ),
                            //             Padding(
                            //               padding: const EdgeInsets.all(3),
                            //               child: Container(
                            //                 width: size.width * 0.22,
                            //                 decoration: ShapeDecoration(
                            //                   gradient: const LinearGradient(
                            //                       colors: [Color(0xFFF3F3F3), Color(0xFFE0E0E0)]),
                            //                   shape: RoundedRectangleBorder(
                            //                     borderRadius: BorderRadius.circular(18),
                            //                   ),
                            //                 ),
                            //                 child: Padding(
                            //                   padding: const EdgeInsets.only(left: 8.0, top: 6, bottom: 6),
                            //                   child: Column(
                            //                     crossAxisAlignment: CrossAxisAlignment.start,
                            //                     mainAxisSize: MainAxisSize.min,
                            //                     mainAxisAlignment: MainAxisAlignment.center,
                            //                     children: [
                            //                       CustomeText(
                            //                         text:
                            //                         '${controller.fetchLeadsModel?.stats?.invitationCall}',
                            //                         fontSize: 28,
                            //                         fontWeight: FontWeight.w700,
                            //                         color: Colors.black,
                            //                       ),
                            //                       const Text(
                            //                         'Demo\nScheduled',
                            //                         style: TextStyle(
                            //                           color: Colors.black,
                            //                           fontSize: 12,
                            //                           fontWeight: FontWeight.w600,
                            //                         ),
                            //                         textAlign: TextAlign.start,
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 ),
                            //               ),
                            //             ),
                            //             Padding(
                            //               padding: const EdgeInsets.all(3),
                            //               child: Container(
                            //                 width: size.width * 0.22,
                            //                 decoration: ShapeDecoration(
                            //                   gradient: const LinearGradient(
                            //                       colors: [Color(0xFFF3F3F3), Color(0xFFE0E0E0)]),
                            //                   shape: RoundedRectangleBorder(
                            //                     borderRadius: BorderRadius.circular(18),
                            //                   ),
                            //                 ),
                            //                 child: Padding(
                            //                   padding: const EdgeInsets.only(left: 8.0, top: 6, bottom: 6),
                            //                   child: Column(
                            //                     crossAxisAlignment: CrossAxisAlignment.start,
                            //                     mainAxisSize: MainAxisSize.min,
                            //                     mainAxisAlignment: MainAxisAlignment.center,
                            //                     children: [
                            //                       CustomeText(
                            //                         text: '${controller.fetchLeadsModel?.stats?.followup}',
                            //                         fontSize: 28,
                            //                         fontWeight: FontWeight.w700,
                            //                         color: Colors.black,
                            //                       ),
                            //                       const Text(
                            //                         'Demo\nDone',
                            //                         style: TextStyle(
                            //                           color: Colors.black,
                            //                           fontSize: 12,
                            //                           fontWeight: FontWeight.w600,
                            //                         ),
                            //                         textAlign: TextAlign.start,
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 ),
                            //               ),
                            //             ),
                            //             Padding(
                            //               padding: const EdgeInsets.all(3),
                            //               child: Container(
                            //                 width: size.width * 0.22,
                            //                 decoration: ShapeDecoration(
                            //                   gradient: const LinearGradient(
                            //                       colors: [Color(0xFF3B3B3B), Color(0xFF4A4A4A)]),
                            //                   shape: RoundedRectangleBorder(
                            //                     borderRadius: BorderRadius.circular(18),
                            //                   ),
                            //                 ),
                            //                 child: Padding(
                            //                   padding: const EdgeInsets.only(left: 8.0, top: 6, bottom: 6),
                            //                   child: Column(
                            //                     crossAxisAlignment: CrossAxisAlignment.start,
                            //                     mainAxisSize: MainAxisSize.min,
                            //                     mainAxisAlignment: MainAxisAlignment.center,
                            //                     children: [
                            //                       CustomeText(
                            //                         text: '${controller.fetchLeadsModel?.stats?.closed}',
                            //                         fontSize: 28,
                            //                         fontWeight: FontWeight.w700,
                            //                         color: Colors.white,
                            //                       ),
                            //                       const Text(
                            //                         'Leads\nClosed',
                            //                         style: TextStyle(
                            //                           color: Colors.white,
                            //                           fontSize: 12,
                            //                           fontWeight: FontWeight.w600,
                            //                         ),
                            //                         textAlign: TextAlign.start,
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 ),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       )),
                            // ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: kPadding, top: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: CustomeText(
                                  text: 'Leads Type',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: kPadding, top: 8),
                              child: SizedBox(
                                  height: size.height * 0.13,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      LeadType(
                                        value: controller
                                            .fetchLeadsModel?.stats?.hot
                                            .toString(),
                                        subHeading: 'Hot Leads',
                                      ),
                                      LeadType(
                                        value: controller
                                            .fetchLeadsModel?.stats?.warm
                                            .toString(),
                                        subHeading: 'Warm Leads',
                                        colors: const [
                                          Color(0xFFFDDC9C),
                                          Color(0xFFDDA53B)
                                        ],
                                      ),

                                      // Padding(
                                      //   padding: const EdgeInsets.all(3),
                                      //   child: Container(
                                      //     width: size.width * 0.3,
                                      //     decoration: ShapeDecoration(
                                      //       gradient: const LinearGradient(
                                      //           colors: [Color(0xFFFF2600), Color(0xFFFF6130)]),
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.circular(18),
                                      //       ),
                                      //     ),
                                      //     child: Padding(
                                      //       padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
                                      //       child: Column(
                                      //         crossAxisAlignment: CrossAxisAlignment.start,
                                      //         mainAxisSize: MainAxisSize.min,
                                      //         mainAxisAlignment: MainAxisAlignment.center,
                                      //         children: [
                                      //           CustomeText(
                                      //             text: '${controller.fetchLeadsModel?.stats?.hot}',
                                      //             fontSize: 31,
                                      //             fontWeight: FontWeight.w700,
                                      //             color: Colors.white,
                                      //           ),
                                      //           const Text(
                                      //             'Hot Leads',
                                      //             style: TextStyle(
                                      //               color: Colors.white,
                                      //               fontSize: 15,
                                      //               fontWeight: FontWeight.w600,
                                      //             ),
                                      //             textAlign: TextAlign.start,
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      // Padding(
                                      //   padding: const EdgeInsets.all(3),
                                      //   child: Container(
                                      //     width: size.width * 0.3,
                                      //     decoration: ShapeDecoration(
                                      //       gradient: const LinearGradient(
                                      //           colors: [Color(0xFFFDDC9C), Color(0xFFDDA53B)]),
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.circular(18),
                                      //       ),
                                      //     ),
                                      //     child: Padding(
                                      //       padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
                                      //       child: Column(
                                      //         crossAxisAlignment: CrossAxisAlignment.start,
                                      //         mainAxisSize: MainAxisSize.min,
                                      //         mainAxisAlignment: MainAxisAlignment.center,
                                      //         children: [
                                      //           CustomeText(
                                      //             text: '${controller.fetchLeadsModel?.stats?.warm}',
                                      //             fontSize: 31,
                                      //             fontWeight: FontWeight.w700,
                                      //             color: Colors.white,
                                      //           ),
                                      //           const Text(
                                      //             'Warm Leads',
                                      //             style: TextStyle(
                                      //               color: Colors.white,
                                      //               fontSize: 15,
                                      //               fontWeight: FontWeight.w600,
                                      //             ),
                                      //             textAlign: TextAlign.start,
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ),
                                      //
                                      // ),
                                      LeadType(
                                        value: controller
                                            .fetchLeadsModel?.stats?.cold
                                            .toString(),
                                        subHeading: 'Cold Leads',
                                        colors: const [
                                          Color(0xFF3CDCDC),
                                          Color(0xFF12BCBC)
                                        ],
                                      ),
                                      LeadType(
                                        onTap: () {
                                          CustomBottomSheet.show(
                                            context: context,
                                            body: const LeadsPopup(
                                              title: 'Bin',
                                              status: 'Bin',
                                            ),
                                          );
                                        },
                                        value: controller.fetchLeadsModel?.stats?.bin.toString(),
                                        subHeading: 'Bin',
                                        colors: const [
                                          Color(0xFF3B3B3B),
                                          Color(0xFF4A4A4A)
                                        ],
                                      ),
                                      LeadType(
                                        value: controller.fetchLeadsModel?.stats
                                            ?.appDownloads
                                            .toString(),
                                        subHeading: 'App Downloads',
                                        colors: const [
                                          Color(0xFF3B3B3B),
                                          Color(0xFF4A4A4A)
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  child: CustomTextField(
                                    hintText: 'Search',
                                    hintStyle: TextStyle(color: Colors.white),
                                    prefixIcon: ImageView(
                                      height: 20,
                                      width: 20,
                                      borderRadiusValue: 0,
                                      color: Colors.white,
                                      margin: EdgeInsets.only(
                                          left: kPadding, right: kPadding),
                                      fit: BoxFit.contain,
                                      assetImage: AppAssets.searchIcon,
                                    ),
                                    margin: EdgeInsets.only(
                                        left: kPadding,
                                        right: kPadding,
                                        top: kPadding,
                                        bottom: kPadding),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: kPadding),
                                  child: GestureDetector(
                                    onTap: () async {},
                                    child: Container(
                                      decoration: ShapeDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment(0.00, -1.00),
                                          end: Alignment(0, 1),
                                          colors: [
                                            Color(0xFF383838),
                                            Color(0xFF282828)
                                          ],
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(21.60),
                                        ),
                                      ),
                                      child: PopupMenuButton(
                                        child: Padding(
                                          padding: const EdgeInsets.all(13),
                                          child: Image.asset(
                                            AppAssets.filter,
                                            height: size.height * 0.04,
                                          ),
                                        ),
                                        onSelected: (value) async {
                                          await context
                                              .read<MembersController>()
                                              .fetchLeads(
                                                  status: status,
                                                  priority: value,
                                                  page: '1');
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry>[
                                          const PopupMenuItem(
                                            value: 'All',
                                            child: Text('All'),
                                          ), const PopupMenuItem(
                                            value: 'Newest',
                                            child: Text('Newest'),
                                          ),
                                          const PopupMenuItem(
                                            value: 'Oldest',
                                            child: Text('Oldest'),
                                          ),
                                          const PopupMenuItem(
                                            value: 'Today',
                                            child: Text('Today'),
                                          ),
                                          const PopupMenuItem(
                                            value: 'Hot',
                                            child: Text('Hot'),
                                          ),
                                          const PopupMenuItem(
                                            value: 'Cold',
                                            child: Text('Cold'),
                                          ),
                                          const PopupMenuItem(
                                            value: 'Warm',
                                            child: Text('Warm'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
            body: Stack(
              children: [
                controller.fetchLeadsModel?.data== null
                    ? const Center(child: NoDataFound())
                    : ListView.builder(
                        itemCount:
                            controller.fetchLeadsModel?.data?.length ?? 0,
                        padding: EdgeInsets.only(bottom: size.height * 0.13),
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.only(
                                  left: kPadding, right: kPadding),
                              child: Container(
                                decoration: decoration,
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: RowCart(
                                      tabIndex: tabIndex,
                                      listIndex: index,
                                      guestId: controller
                                          .fetchLeadsModel?.data?[index].id
                                          .toString(),
                                      image: controller.fetchLeadsModel
                                          ?.data?[index].profilePhoto,
                                      name: controller.fetchLeadsModel
                                          ?.data?[index].firstName,
                                      city: controller.fetchLeadsModel
                                          ?.data?[index].cityName,
                                      phone: controller
                                          .fetchLeadsModel?.data?[index].mobile,
                                      date: controller.fetchLeadsModel
                                          ?.data?[index].demoDate,
                                      time: controller.fetchLeadsModel
                                          ?.data?[index].demoTime,
                                      priority: controller.fetchLeadsModel
                                          ?.data?[index].priority,
                                      demoId: controller
                                          .fetchLeadsModel?.data?[index].demoId
                                          .toString(),
                                      memberId: controller.fetchLeadsModel
                                          ?.data?[index].memberId
                                          .toString(),
                                    )),
                              ));
                        },
                      ),
                if (controller.showItem == true)
                  Padding(
                    padding: EdgeInsets.only(bottom: size.height * 0.1),
                    child: Container(
                      decoration: controller.showItem
                          ? BoxDecoration(color: Colors.grey.withOpacity(0.1))
                          : null,
                      child: Column(
                        mainAxisSize: controller.showItem
                            ? MainAxisSize.max
                            : MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (controller.showItem == true)
                            DashboardMoreMenu(
                              showLeadItem: true,
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            floatingActionButton: tabIndex == 0
                ? Padding(
                    padding: EdgeInsets.only(bottom: size.height * 0.1),
                    child: GestureDetector(
                      onTap: () async {
                        controller.changeStatus();
                        // if(controller.showItem==false){
                        //   context.read<MembersController>().showItem=true;
                        //
                        // }else{
                        //   context.read<MembersController>().showItem=false;
                        // }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: primaryGradient, shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(kPadding),
                          child: Image.asset(
                            AppAssets.addIcon,
                            height: 30,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                : null);
      },
    );
  }
}

class RowCart extends StatefulWidget {

  int? tabIndex;
  int? listIndex;
  String? guestId;
  String? image;
  String? name;
  String? city;
  String? phone;
  String? date;
  String? time;
  String? priority;
  String? demoId;
  String? memberId;
  RowCart({

    this.tabIndex,
    this.listIndex,
    this.guestId,
    this.image,
    this.name,
    this.city,
    this.phone,
    this.date,
    this.time,
    this.priority,
    this.demoId,
    this.memberId,
    super.key,
  });

  @override
  State<RowCart> createState() => _RowCartState();
}

class _RowCartState extends State<RowCart> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeConroller = TextEditingController();
  Future<void> _showDialog(
    BuildContext context,
    String? guestId,
    String? feedback,
    bool changePopUp2,
    bool? changePopup,
    String? priority,
  ) async {
    return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      // barrierDismissible: true,
      builder: (BuildContext context) {
        return changePopup == false
            ? ModelDialogBox(
                guestId: guestId ?? '',
                feedback: feedback ?? '',
                changePopUp: changePopUp2,
              )
            : ModelDialogBoxForRescheduled(
                guestId: guestId ?? '',
          priority:priority??'' ,
              );
      },
    );
  }

  Future<void> _showDialogDemoScheduled(BuildContext context, guestId,priority) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        title: CustomeText(
          text: 'Reschedule',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              title: 'Date',
              hintText: 'dd-mm-yyyy',
              controller: dateController,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1750),
                  lastDate: DateTime(2101),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        popupMenuTheme: PopupMenuThemeData(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        cardColor: Colors.white,

                        colorScheme: Theme.of(context).colorScheme.copyWith(
                              primary: Colors.white, // <-- SEE HERE
                              onPrimary: Colors.black, // <-- SEE HERE
                              onSurface: Colors.white,
                            ),

                        // Input
                        inputDecorationTheme: const InputDecorationTheme(
                            // labelStyle: GoogleFonts.greatVibes(), // Input label
                            ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedDate != null) {
                  dateController.text =
                      "${pickedDate.day.toString().padLeft(2, "0")}-${pickedDate.month.toString().padLeft(2, "0")}-${pickedDate.year}";
                }
              },
              readOnly: true,
            ),
            AppTextField(
              title: 'Time',
              hintText: 'hh:mm',
              controller: timeConroller,
              onTap: () async {
                TimeOfDay? time = await showTimePicker(
                  context: context,
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        popupMenuTheme: PopupMenuThemeData(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        cardColor: Colors.white,

                        colorScheme: Theme.of(context).colorScheme.copyWith(
                              primary: Colors.white, // <-- SEE HERE
                              onPrimary: Colors.black, // <-- SEE HERE
                              onSurface: Colors.white,
                            ),

                        // Input
                        inputDecorationTheme: const InputDecorationTheme(
                            // labelStyle: GoogleFonts.greatVibes(), // Input label
                            ),
                      ),
                      child: child!,
                    );
                  },
                  initialTime: TimeOfDay.now(),
                );

                if (time != null) {
                  timeConroller.text = time.format(context);
                }
              },
              readOnly: true,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Back'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<ListsControllers>().rescheduledCall(
                  context: context,
                  guestId: guestId,
                  reason: '',
                  date: dateController.text,
                  time: timeConroller.text, LMSStep: 'Demo Scheduled ', priority: priority, demoRescheduleRemark: '');
              // context.pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDialogIncomplete(
    BuildContext context,
    String? guestId,
    String? priority,
  ) async {
    return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            context.pop();
          },
          child: FocusScope(
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                context.pop();
              }
            },
            child: ModelDialogBoxIncomplete(
              guestId: guestId ?? '',
              priority:priority??'' ,
            ),
          ),
        );
      },
    );
  }

  Color? pupUpTextColor = const Color(0xFFA0A0A0);

  int? newIndex = -1;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return widget.tabIndex == 0
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  context.pushNamed(Routs.leadMemberProfile,
                      extra: GuestProfileDetails(guestId: '$widget.guestId'));
                  context.pushNamed(Routs.memberProfileDetails,
                      extra:
                          MemberProfileDetails(memberId: '${widget.memberId}'));
                },
                child: Row(
                  children: [
                    widget.image == null
                        ? CircleAvatar(
                            maxRadius: size.height * 0.02,
                            child: Image.asset(
                              AppAssets.userIcon,
                              height: 15,
                            ),
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(widget.image ?? ''),
                            maxRadius: size.height * 0.02,
                          ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: size.width * 0.12,
                      child: CustomeText(
                        text: widget.name ?? '',
                        maxLines: 1,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: const Alignment(0.61, -0.79),
                          end: const Alignment(-0.61, 0.79),
                          colors: widget.priority == 'Hot'
                              ? [
                                  const Color(0xFFFF2600),
                                  const Color(0xFFFF6130)
                                ]
                              : widget.priority == 'Warm'
                                  ? [
                                      const Color(0xFFFDDC9C),
                                      const Color(0xFFDDA53B)
                                    ]
                                  : [
                                      const Color(0xFF3CDCDC),
                                      const Color(0xFF12BCBC)
                                    ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(39),
                        ),
                      ),
                      child: SizedBox(
                        width: size.width * 0.11,
                        child: Center(
                          child: CustomPopUpMenu(
                            showText: true,
                            priority: widget.priority,
                            onSelected: (v) async {
                              await context
                                  .read<MembersController>()
                                  .updateLeadPriority(
                                      context: context,
                                      guestId: widget.guestId,
                                      feedback: '',
                                      priority: v,
                                      remark: '')
                                  .whenComplete(
                                () async {
                                  await context
                                      .read<MembersController>()
                                      .fetchLeads(
                                          status: 'New',
                                          priority: '',
                                          page: '1');
                                },
                              );
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                              PopupMenuItem(
                                // height: size.height*0.05,
                                value: 'Hot',
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomeText(
                                          text: 'Hot',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 2,
                                      color: Colors.grey.shade300,
                                    )
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Warm',
                                height: size.height * 0.04,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomeText(
                                          text: 'Warm',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 2,
                                      color: Colors.grey.shade300,
                                    )
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Cold',
                                height: size.height * 0.04,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomeText(
                                      text: 'Cold',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      newIndex = widget.listIndex;
                      setState(() {});
                      await context.read<MembersController>().updateLeadStatus(
                            context: context,
                            guestId: widget.guestId,
                            status: 'Invitation Call',
                          );
                    },
                    child: Container(
                      decoration: ShapeDecoration(
                        gradient: newIndex == widget.listIndex
                            ? primaryGradient
                            : const LinearGradient(
                                colors: [Colors.white, Colors.white]),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(39),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8, top: 4, bottom: 4),
                        child: CustomeText(
                          text: 'Move to IC',
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Container(
              //   decoration: const BoxDecoration(color: Color(0xFFD9D9D9), shape: BoxShape.circle),
              //   child: GestureDetector(
              //     onTap: () async {
              //       await context.read<MembersController>().callUser(
              //         mobileNo: phone,
              //       );
              //       await context.read<MembersController>().updateLeadStatus(
              //         context: context,
              //         guestId: guestId,
              //         status: 'Invitation Call',
              //       );
              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.all(1),
              //       child: ImageView(
              //         assetImage: AppAssets.call,
              //         height: size.height * 0.02,
              //         color: Colors.black,
              //       ),
              //     ),
              //   ),
              // ),
              // PopupMenuButton(
              //   color: CupertinoColors.white,
              //   //  onSelected: (value) async{
              //   //    print('check menu ${guestId}');
              //   //
              //   await   showDialog<String>(
              //        context: context,
              //        builder: (BuildContext context) => ModelDialogBox(guestId:guestId??'' ,status: 'Invitation Call',)
              //      );
              //   //   // await context.pushNamed(Routs.modelDialogBox,extra: ModelDialogBox(guestId: '1',));
              //   //
              //   //  },
              //   shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
              //   onSelected: (value) {
              //     print(value);
              //     _showDialog(context, guestId, value, false).whenComplete(
              //           () async {
              //         await context
              //             .read<MembersController>()
              //             .fetchLeads(status: 'New ', priority: '', page: '1');
              //       },
              //     );
              //   },
              //   itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              //     PopupMenuItem(
              //       // height: size.height*0.05,
              //       value: 'Interested',
              //       child: Padding(
              //         padding: const EdgeInsets.only(left: 10.0),
              //         child: CustomeText(
              //           text: 'Interested',
              //           color: Colors.black,
              //           fontWeight: FontWeight.w600,
              //           fontSize: 12,
              //         ),
              //       ),
              //     ),
              //     PopupMenuItem(
              //       value: 'Not confirm',
              //       height: size.height * 0.04,
              //       child: Padding(
              //         padding: const EdgeInsets.only(left: 10.0),
              //         child: CustomeText(
              //           text: 'Not confirm',
              //           color: Colors.black,
              //           fontWeight: FontWeight.w600,
              //           fontSize: 12,
              //         ),
              //       ),
              //     ),
              //   ],
              //   child: const Icon(Icons.more_vert),
              // ),
            ],
          )
        : widget.tabIndex == 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      widget.image == null
                          ? CircleAvatar(
                              maxRadius: size.height * 0.02,
                              child: Image.asset(
                                AppAssets.userIcon,
                                height: 15,
                              ),
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(widget.image ?? ''),
                              maxRadius: size.height * 0.02,
                            ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: size.width * 0.12,
                        child: CustomeText(
                          text: widget.name ?? '',
                          maxLines: 1,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  CustomeText(
                    text: widget.date ?? '07-02-2024',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  CustomeText(
                    text: widget.time ?? '12:02 AM',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: const Alignment(0.61, -0.79),
                          end: const Alignment(-0.61, 0.79),
                          colors: widget.priority == 'Hot'
                              ? [
                                  const Color(0xFFFF2600),
                                  const Color(0xFFFF6130)
                                ]
                              : widget.priority == 'Warm'
                                  ? [
                                      const Color(0xFFFDDC9C),
                                      const Color(0xFFDDA53B)
                                    ]
                                  : [
                                      const Color(0xFF3CDCDC),
                                      const Color(0xFF12BCBC)
                                    ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(39),
                        ),
                      ),
                      child: SizedBox(
                        width: size.width * 0.11,
                        child: Center(
                          child: CustomPopUpMenu(
                            showText: true,
                            priority: widget.priority,
                            onSelected: (v) async {
                              await context.read<MembersController>().updateLeadPriority(
                                      context: context,
                                      guestId: widget.guestId,
                                      feedback: '',
                                      priority: v,
                                      remark: '')
                                  .whenComplete(
                                () async {
                                  await context
                                      .read<MembersController>()
                                      .fetchLeads(
                                          status: 'Invitation Call',
                                          priority: '',
                                          page: '1');
                                },
                              );
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                              PopupMenuItem(
                                // height: size.height*0.05,
                                value: 'Hot',
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomeText(
                                          text: 'Hot',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 2,
                                      color: Colors.grey.shade300,
                                    )
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Warm',
                                height: size.height * 0.04,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomeText(
                                          text: 'Warm',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 2,
                                      color: Colors.grey.shade300,
                                    )
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Cold',
                                height: size.height * 0.04,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomeText(
                                      text: 'Cold',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  CustomPopUpMenu(
                    onSelected: (v) async {
                      if (v == 'Schedule demo') {
                        context
                            .pushNamed(Routs.createDemo,
                                extra: CreateDemo(
                                  guestId: widget.guestId ?? '',
                                  image: widget.image,
                                  name: widget.name,
                                ))
                           ;
                      } else if (v == 'Reschedule call') {
                        _showDialog(context, widget.guestId, '', true, true, widget.priority);
                      } else {
                        await context
                            .read<ListsControllers>()
                            .deleteLead(
                                context: context, guestId: widget.guestId ?? '')
                            .whenComplete(
                          () async {
                            await context.read<MembersController>().fetchLeads(
                                status: 'Invitation Call',
                                priority: '',
                                page: '1');
                          },
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        height: size.height * 0.04,
                        value: 'Schedule demo',
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomeText(
                                  text: 'Schedule demo',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 2,
                              color: Colors.grey.shade300,
                            )
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'Reschedule call',
                        height: size.height * 0.04,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomeText(
                                  text: 'Reschedule call',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 2,
                              // height: 10,
                              color: Colors.grey.shade300,
                            )
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'Move to bin',
                        height: size.height * 0.03,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomeText(
                              text: 'Move to bin',
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                  // PopupMenuButton(
                  //   color: CupertinoColors.white,
                  //   shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  //   onSelected: (value) {
                  //     print(value);
                  //     // _showDialog(context, widget.guestId, value, false).whenComplete(
                  //     //       () async {
                  //     //     await context
                  //     //         .read<MembersController>()
                  //     //         .fetchLeads(status: 'New ', priority: '', page: '1');
                  //     //   },
                  //     // );
                  //   },
                  //   itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  //     PopupMenuItem(
                  //       height: size.height*0.05,
                  //       value: 'Schedule demo',
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           CustomeText(
                  //             text: 'Schedule demo',
                  //             color: Colors.black,
                  //             fontWeight: FontWeight.w600,
                  //             fontSize: 12,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     PopupMenuItem(
                  //       value: 'Reschedule call',
                  //       height: size.height * 0.04,
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           CustomeText(
                  //             text: 'Reschedule call',
                  //             color: Colors.black,
                  //             fontWeight: FontWeight.w600,
                  //             fontSize: 12,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     PopupMenuItem(
                  //       value: 'Move to bin',
                  //       height: size.height * 0.04,
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           CustomeText(
                  //             text: 'Move to bin',
                  //             color: Colors.black,
                  //             fontWeight: FontWeight.w600,
                  //             fontSize: 12,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  //   child: const Icon(Icons.more_vert),
                  // ),

                  // GestureDetector(
                  //   onTap: () {
                  //     context
                  //         .pushNamed(Routs.createDemo,
                  //         extra: CreateDemo(
                  //           guestId: widget.guestId ?? '',
                  //           name: widget.name,
                  //           image: widget.image,
                  //         ))
                  //         .whenComplete(
                  //           () async {
                  //         await context
                  //             .read<MembersController>()
                  //             .fetchLeads(status: 'Invitation Call ', priority: '', page: '1');
                  //       },
                  //     );
                  //   },
                  //   child: Container(
                  //     decoration: ShapeDecoration(
                  //       gradient: const LinearGradient(
                  //         begin: Alignment(0.00, -1.00),
                  //         end: Alignment(0, 1),
                  //         colors: [Color(0xFFF3F3F3), Color(0xFFE0E0E0)],
                  //       ),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(50),
                  //       ),
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(left: 18, right: 18, top: 4, bottom: 4),
                  //       child: CustomeText(
                  //         text: 'Demo',
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 10,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              )
            : widget.tabIndex == 2
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          widget.image == null
                              ? CircleAvatar(
                                  maxRadius: size.height * 0.02,
                                  child: Image.asset(
                                    AppAssets.userIcon,
                                    height: 15,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(widget.image ?? ''),
                                  maxRadius: size.height * 0.02,
                                ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: size.width * 0.12,
                            child: CustomeText(
                              text: widget.name ?? '',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      CustomeText(
                        text: widget.date ?? '07-02-2024',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomeText(
                        text: widget.time ?? '12:02 AM',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      // CustomeText(
                      //   text: city ?? 'Bhilai',
                      //   fontSize: 12,
                      //   fontWeight: FontWeight.w500,
                      // ),
                      Container(
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: const Alignment(0.61, -0.79),
                            end: const Alignment(-0.61, 0.79),
                            colors: widget.priority == 'Hot'
                                ? [
                                    const Color(0xFFFF2600),
                                    const Color(0xFFFF6130)
                                  ]
                                : widget.priority == 'Worm'
                                    ? [
                                        const Color(0xFFFDDC9C),
                                        const Color(0xFFDDA53B)
                                      ]
                                    : [
                                        const Color(0xFF3CDCDC),
                                        const Color(0xFF12BCBC)
                                      ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(39),
                          ),
                        ),
                        child: SizedBox(
                          width: size.width * 0.11,
                          child: Center(
                            child: CustomPopUpMenu(
                              showText: true,
                              priority: widget.priority,
                              onSelected: (v) async {
                                await context
                                    .read<MembersController>()
                                    .updateLeadPriority(
                                        context: context,
                                        guestId: widget.guestId,
                                        feedback: '',
                                        priority: v,
                                        remark: '')
                                    .whenComplete(
                                  () async {
                                    await context
                                        .read<MembersController>()
                                        .fetchLeads(
                                            status: 'Demo Scheduled',
                                            priority: '',
                                            page: '1');
                                  },
                                );
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry>[
                                PopupMenuItem(
                                  // height: size.height*0.05,
                                  value: 'Hot',
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomeText(
                                            text: 'Hot',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        thickness: 2,
                                        color: Colors.grey.shade300,
                                      )
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'Warm',
                                  height: size.height * 0.04,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomeText(
                                            text: 'Warm',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        thickness: 2,
                                        color: Colors.grey.shade300,
                                      )
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'Cold',
                                  height: size.height * 0.04,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomeText(
                                        text: 'Cold',
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      CustomPopUpMenu(
                        onSelected: (v) async {
                          if (v == 'Demo done') {
                            await showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    DemoDoneFormDemoScheduled(
                                      demoId: widget.demoId ?? '',
                                      feedback: '',
                                    ));
                            // await showModalBottomSheet(
                            //     backgroundColor: Colors.transparent,
                            //     context: context,
                            //     clipBehavior: Clip.antiAlias,
                            //     isScrollControlled: true,
                            //     shape: const OutlineInputBorder(
                            //         borderRadius: BorderRadius.only(
                            //             topLeft: Radius.circular(18),
                            //             topRight: Radius.circular(18))),
                            //     builder: (context) => DemoDoneForm(
                            //           title: 'List Update',
                            //           demoId: widget.demoId,
                            //         )).whenComplete(
                            //   () async {
                            //     await context
                            //         .read<MembersController>()
                            //         .fetchLeads(
                            //             status: 'Demo Sheduled',
                            //             priority: '',
                            //             page: '1');
                            //   },
                            // );
                          }
                          else if (v == 'Move to bin') {
                            await context.read<ListsControllers>().deleteLead(context: context, guestId: widget.guestId ?? '').whenComplete(
                              () async {
                                await context
                                    .read<MembersController>()
                                    .fetchLeads(
                                        status: 'Demo Scheduled',
                                        priority: '',
                                        page: '1');
                              },
                            );
                          } else if (v == 'Reschedule') {
                            _showDialogDemoScheduled(context, widget.guestId,widget.priority);
                          } else if (v == 'Incomplete') {
                            _showDialogIncomplete(context, widget.guestId,widget.priority);
                          } else {
                            context
                                .pushNamed(Routs.createDemo,
                                    extra: CreateDemo(
                                      guestId: widget.guestId ?? '',
                                      name: widget.name,
                                      image: widget.image,
                                    ))
                                .whenComplete(
                              () async {
                                await context
                                    .read<MembersController>()
                                    .fetchLeads(
                                        status: 'Demo Scheduled',
                                        priority: '',
                                        page: '1');
                              },
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                          PopupMenuItem(
                            value: 'Demo done',
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomeText(
                                      text: 'Demo done',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.grey.shade300,
                                )
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Reschedule',
                            height: size.height * 0.04,
                            child: Column(
                              children: [
                                CustomeText(
                                  text: 'Reschedule',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.grey.shade300,
                                )
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Incomplete',
                            height: size.height * 0.05,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomeText(
                                  text: 'Incompleted',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.grey.shade300,
                                )
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Move to bin',
                            height: size.height * 0.05,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomeText(
                                      text: 'Move to bin',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                                Text('')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : widget.tabIndex == 3
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              widget.image == null
                                  ? Image.asset(AppAssets.u1)
                                  : CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(widget.image ?? ''),
                                      maxRadius: size.height * 0.02,
                                    ),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: size.width * 0.12,
                                child: CustomeText(
                                  text: widget.name ?? '',
                                  fontSize: 12,
                                  maxLines: 1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          CustomeText(
                            text: widget.date ?? '07-02-2024',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          CustomeText(
                            text: widget.time ?? '12:02 AM',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          Container(
                            decoration: ShapeDecoration(
                              gradient: LinearGradient(
                                begin: const Alignment(0.61, -0.79),
                                end: const Alignment(-0.61, 0.79),
                                colors: widget.priority == 'Warm'
                                    ? [
                                        const Color(0xFFFDDC9C),
                                        const Color(0xFFDDA53B)
                                      ]
                                    : widget.priority == 'Hot'
                                        ? [
                                            const Color(0xFFFF2600),
                                            const Color(0xFFFF6130)
                                          ]
                                        : [
                                            const Color(0xFF3CDCDC),
                                            const Color(0xFF12BCBC)
                                          ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(39),
                              ),
                            ),
                            child: SizedBox(
                              width: size.width * 0.11,
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  child: CustomPopUpMenu(
                                    showText: true,
                                    priority: widget.priority,
                                    onSelected: (v) async {
                                      await context
                                          .read<MembersController>()
                                          .updateLeadPriority(
                                              context: context,
                                              guestId: widget.guestId,
                                              feedback: '',
                                              priority: v,
                                              remark: '')
                                          .whenComplete(
                                        () async {
                                          await context
                                              .read<MembersController>()
                                              .fetchLeads(
                                                  status: ' Follow Up',
                                                  priority: '',
                                                  page: '1');
                                        },
                                      );
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry>[
                                      PopupMenuItem(
                                        // height: size.height*0.05,
                                        value: 'Hot',
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: CustomeText(
                                            text: 'Hot',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'Warm',
                                        height: size.height * 0.04,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: CustomeText(
                                            text: 'Warm',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'Cold',
                                        height: size.height * 0.04,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: CustomeText(
                                            text: 'Cold',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //
                          //   },
                          //   child: Container(
                          //     decoration: ShapeDecoration(
                          //       gradient: const LinearGradient(
                          //         begin: Alignment(0.00, -1.00),
                          //         end: Alignment(0, 1),
                          //         colors: [
                          //           Color(0xFFF3F3F3),
                          //           Color(0xFFE0E0E0)
                          //         ],
                          //       ),
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(50),
                          //       ),
                          //     ),
                          //     child: Padding(
                          //       padding: const EdgeInsets.only(
                          //           left: 18, right: 18, top: 4, bottom: 4),
                          //       child: CustomeText(
                          //         text: 'Close',
                          //         fontWeight: FontWeight.w500,
                          //         fontSize: 10,
                          //         color: Colors.black,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          CustomPopUpMenu(
                            onSelected: (v) async {
                              if (v == 'Close') {
                                _showDialog(context, widget.guestId, '', true, false,'').whenComplete(
                                  () async {
                                    await context
                                        .read<MembersController>()
                                        .fetchLeads(
                                            status: 'Follow Up',
                                            priority: '',
                                            page: '1');
                                  },
                                );
                              } else if (v == 'Schedule follow up') {
                                _showDialogDemoScheduled(
                                    context, widget.guestId,widget.priority);
                              } else {
                                await context
                                    .read<ListsControllers>()
                                    .deleteLead(
                                        context: context,
                                        guestId: widget.guestId ?? '')
                                    .whenComplete(
                                  () async {
                                    await context
                                        .read<MembersController>()
                                        .fetchLeads(
                                            status: 'Follow Up',
                                            priority: '',
                                            page: '1');
                                  },
                                );
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                              PopupMenuItem(
                                height: size.height * 0.04,
                                value: 'Close',
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomeText(
                                          text: 'Close',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 2,
                                      color: Colors.grey.shade300,
                                    )
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Schedule follow up',
                                height: size.height * 0.04,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomeText(
                                          text: 'Schedule follow up',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 2,
                                      // height: 10,
                                      color: Colors.grey.shade300,
                                    )
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Move to bin',
                                height: size.height * 0.03,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomeText(
                                      text: 'Move to bin',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : widget.tabIndex == 4
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  widget.image == null
                                      ? CircleAvatar(
                                          maxRadius: size.height * 0.02,
                                          child: Image.asset(
                                            AppAssets.userIcon,
                                            height: 15,
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(widget.image ?? ''),
                                          maxRadius: size.height * 0.02,
                                        ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: size.width * 0.17,
                                    child: CustomeText(
                                      text: widget.name ?? '',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              CustomeText(
                                text: widget.city ?? 'Raipur',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed(Routs.memberProfileDetails,
                                      extra: MemberProfileDetails(
                                        memberId: widget.memberId ?? '',
                                      ));
                                },
                                child: Container(
                                  decoration: ShapeDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment(0.00, -1.00),
                                      end: Alignment(0, 1),
                                      colors: [
                                        Color(0xFFF3F3F3),
                                        Color(0xFFE0E0E0)
                                      ],
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18, right: 18, top: 4, bottom: 4),
                                    child: CustomeText(
                                      text: 'View Profile',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              // const Icon(Icons.more_vert)
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  widget.image == null
                                      ? Image.asset(AppAssets.u1)
                                      : CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(widget.image ?? ''),
                                          maxRadius: size.height * 0.02,
                                        ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: size.width * 0.17,
                                    child: CustomeText(
                                      text: widget.name ?? '',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              CustomeText(
                                text: widget.city ?? '',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  decoration: ShapeDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment(0.00, -1.00),
                                      end: Alignment(0, 1),
                                      colors: [
                                        Color(0xFFF3F3F3),
                                        Color(0xFFE0E0E0)
                                      ],
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18, right: 18, top: 4, bottom: 4),
                                    child: CustomeText(
                                      text: 'View Profile',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
  }
}

class LeadType extends StatelessWidget {
  String? value;
  String? subHeading;
  List<Color>? colors;
  void Function()? onTap;

  LeadType({
    this.value,
    this.colors,
    this.onTap,
    this.subHeading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(3),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size.width * 0.3,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
                colors: colors ??
                    [const Color(0xFFFF2600), const Color(0xFFFF6130)]),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 6, bottom: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomeText(
                  text: value,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                Text(
                  subHeading ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
