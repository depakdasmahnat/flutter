import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:provider/provider.dart';

import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../models/auth_model/fetchinterestcategory.dart';
import '../../../utils/widgets/appbar.dart';

import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../guest_check_demo/guest_check_demo_step2.dart';

class GuestFaq extends StatefulWidget {
  const GuestFaq({super.key});

  @override
  State<GuestFaq> createState() => _GuestFaqState();
}

class _GuestFaqState extends State<GuestFaq> {

  List item = [
    {
      'image': AppAssets.rocket,
      'first': 'Questions about',
      'second': 'Getting Started',
      'gradiant': primaryGradient,
      'color': const Color(0xFFE1FF41),
    },
    {
      'image': AppAssets.aboutQ,
      'first': 'Questions about',
      'second': 'How to Invest',
      'gradiant': null,
      'color': const Color(0xFFE1FF41),
    },
    {
      'image': AppAssets.rupees,
      'first': 'Questions about',
      'second': 'Payment Meth…',
      'gradiant': null,
      'color': Colors.white,
    }
  ];

  Fetchinterestcategory? fetchInterestCategory;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<GuestControllers>().fetchInterestCategories(context: context, type: 'Faq');
      context.read<GuestControllers>().fetchFaqs(context: context, categoriesId: allText);
    });
    super.initState();
  }

  bool expend = false;
  bool all = false;
  String allText ='All';
  int? changeIndex = -1;
  int? tabIndex =-1;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: () async {
        context.read<GuestControllers>().fetchInterestCategories(context: context, type: 'Faq');
        context.read<GuestControllers>().fetchFaqs(context: context, categoriesId: allText);
      },
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(size.height * 0.08),
            child: CustomAppBar(
              showLeadICon: true,
              title: 'FAQs',

            )),
        body: Consumer<GuestControllers>(
          builder: (context, controller, child) {
            fetchInterestCategory = controller.fetchInterestCategory;
            return Column(
              children: [
                const Text(
                  'Select Relevant Category',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
                // const CustomTextField(
                //   hintText: 'Search',
                //   hintStyle: TextStyle(color: Colors.white),
                //   prefixIcon: ImageView(
                //     height: 20,
                //     width: 20,
                //     borderRadiusValue: 0,
                //     color: Colors.white,
                //     margin: EdgeInsets.only(left: kPadding, right: kPadding),
                //     fit: BoxFit.contain,
                //     assetImage: AppAssets.searchIcon,
                //   ),
                //   margin: EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding, bottom: kPadding),
                // ),
                const SizedBox(
                  height: 20,
                ),
                controller.fetchCategoryLoader == true
                    ? const LoadingScreen(message: 'Loading...')
                    : (fetchInterestCategory?.data.haveData == true)
                        ? SizedBox(
                            height: size.height * 0.11,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                GestureDetector(
                                  onTap:  () async{
                                    all =!all;
                                    allText ='All';
                                    tabIndex =-1;
                                    await context.read<GuestControllers>().fetchFaqs(
                                        context: context,
                                        categoriesId:allText);
                                    setState(() {});
                                  },
                                  child: Container(

                                    decoration:  BoxDecoration(
                                      gradient:all==false? primaryGradient:inActiveGradient,
                                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: kPadding, top: 4, bottom: 4, right: kPadding),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // fetchInterestCategory?.data?[index].path == null
                                          //     ?
                                          Image.asset(
                                            AppAssets.rocket,
                                            height: size.height * 0.04,
                                            color:all==false? Colors.black:Colors.white,
                                          ),

                                           Text(
                                            'All',
                                            style:
                                            TextStyle(
                                              color:all==false?Colors.black :Colors.white,
                                              fontSize: 12,
                                              height: 3,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          // Text(
                                          //   fetchInterestCategory?.data?[index].type ?? '',
                                          //   style:  TextStyle(
                                          //     color:tabIndex ==index?Colors.black: Colors.white,
                                          //     fontSize: 12,
                                          //     fontWeight: FontWeight.w400,
                                          //   ),
                                          //   textAlign: TextAlign.start,
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: fetchInterestCategory?.data?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                                      child: GestureDetector(
                                        onTap: () async {
                                          all =true;
                                          tabIndex =index;
                                          setState(() {});
                                          await context.read<GuestControllers>().fetchFaqs(
                                              context: context,
                                              categoriesId:
                                                  fetchInterestCategory?.data?[index].id.toString() ?? '');

                                        },
                                        child:
                                        Container(
                                          width: size.width * 0.34,
                                          // height: size.width*0.2,
                                          decoration:  BoxDecoration(
                                            gradient: tabIndex ==index?primaryGradient: inActiveGradient,
                                            borderRadius: const BorderRadius.all(Radius.circular(18)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: kPadding, top: 4, bottom: 4, right: kPadding),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                // fetchInterestCategory?.data?[index].path == null
                                                //     ?
                                                Image.asset(
                                                        AppAssets.rocket,
                                                        height: size.height * 0.04,
                                                  color:tabIndex ==index?Colors.black: Colors.white,
                                                      ),
                                                //     :
                                                // Image.network(
                                                //         fetchInterestCategory?.data?[index].path ?? '',
                                                //         height: size.height * 0.04,
                                                //   color:tabIndex ==index?Colors.black: Colors.white,
                                                //       ),
                                                Text(
                                                  fetchInterestCategory?.data?[index].name ?? '',
                                                  style:
                                                  TextStyle(
                                                    color:tabIndex ==index?Colors.black: Colors.white,
                                                    fontSize: 12,
                                                    height: 3,

                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                                // Text(
                                                //   fetchInterestCategory?.data?[index].type ?? '',
                                                //   style:  TextStyle(
                                                //     color:tabIndex ==index?Colors.black: Colors.white,
                                                //     fontSize: 12,
                                                //     fontWeight: FontWeight.w400,
                                                //   ),
                                                //   textAlign: TextAlign.start,
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(kPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomeText(
                        text: 'Frequently Asked Questions',
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                      // CustomeText(
                      //   text: 'View All',
                      //   color: Colors.white,
                      //   fontSize: 14,
                      //   fontWeight: FontWeight.w600,
                      // ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(kPadding),
                //   child: Container(
                //     decoration: BoxDecoration(
                //         gradient: primaryGradient,
                //         borderRadius: BorderRadius.circular(18)
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.all(kPadding),
                //       child:
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               CustomeText(
                //                 text: 'How to create a account?',
                //                 color: Colors.black,
                //                 fontSize: 16,
                //                 fontWeight:FontWeight.w600 ,
                //               ),
                //               CustomeText(
                //                 text: '-',
                //                 color: Colors.black,
                //                 fontSize: 24,
                //                 fontWeight:FontWeight.w600 ,
                //               ),
                //             ],
                //           ),
                //
                //           Padding(
                //             padding: const EdgeInsets.only(top: kPadding,bottom: kPadding),
                //             child: CustomeText(
                //               text: 'Open the Tradebase app to get started and follow the steps. Tradebase doesn’t charge a fee to create or maintain your Tradebase account.',
                //               color: Colors.black,
                //               fontSize: 14,
                //
                //               fontWeight:FontWeight.w400 ,
                //             ),
                //           ),
                //
                //         ],
                //       ),
                //     ),
                //
                //   ),
                // ),

                Expanded(
                  child: controller.fetchFaqsLoader == true
                      ? const LoadingScreen(
                          heightFactor: 0.5,
                        )
                      : (controller.fetchFaqsModel?.data?.haveData == true)
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.fetchFaqsModel?.data?.length ?? 0,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return
                                  Padding(
                                  padding:
                                      const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                                  child: Container(
                                    decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                        gradient: expend == true && changeIndex == index
                                            ? primaryGradient
                                            : const LinearGradient(
                                                colors: [Color(0xFF1B1B1B), Color(0xFF1B1B1B)])),
                                    child:
                                    ExpansionTile(
                                      iconColor:
                                          expend == true && changeIndex == index ? Colors.black : Colors.white,
                                      onExpansionChanged: (value) {
                                        expend = value;
                                        changeIndex = index;
                                        setState(() {});
                                      },
                                      title: CustomText1(
                                        text: controller.fetchFaqsModel?.data?[index].question,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            expend == true && changeIndex == index ? Colors.black : Colors.white,
                                      ),
                                      children: <Widget>[
                                        ListTile(
                                            title: CustomText1(
                                          text: controller.fetchFaqsModel?.data?[index].answer,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: expend == true && changeIndex == index
                                              ? Colors.black
                                              : Colors.white,
                                        )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const NoDataFound(
                              heightFactor: 0.5,
                            ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class CustomeText extends StatelessWidget {
  String? text;
  Color? color;
  double? fontSize;
  double? textHeight;
  TextAlign? textAlign;
  FontWeight? fontWeight;
  int? maxLines;

  CustomeText({
    this.color,
    this.text,
    this.fontWeight,
    this.fontSize,
    this.textHeight,
    this.textAlign,
    this.maxLines,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Text(
      text ?? '',
      maxLines: maxLines,
      style: TextStyle(

          overflow: TextOverflow.ellipsis,
          color: color,

          fontSize: fontSize,
          fontWeight: fontWeight,
          height: textHeight),
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}
