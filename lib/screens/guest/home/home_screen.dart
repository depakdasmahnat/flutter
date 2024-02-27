import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_flip_card/flipcard/gesture_flip_card.dart';
// import 'package:flutter_flip_card/modal/flip_side.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_string_extension.dart';
import 'package:mrwebbeast/core/services/database/local_database.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:mrwebbeast/screens/guest/home/banners.dart';
import 'package:mrwebbeast/screens/member/feeds/feed_detail.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
import 'package:mrwebbeast/utils/widgets/custom_text_field.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:mrwebbeast/utils/widgets/gradient_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../../controllers/check_demo_controller/check_demo_controller.dart';
import '../../../controllers/feeds/feeds_controller.dart';
import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../core/constant/gradients.dart';
import '../../../core/route/route_paths.dart';
import '../../../models/feeds/feeds_data.dart';
import '../../../models/guest_Model/fetchfeedcategoriesmodel.dart';

import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../../member/feeds/feeds_card.dart';
import 'guest_profiles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  List<FeedsData>? feeds;
  FeedCategory? selectedFilter;

  DateTime currentDate = DateTime.now();

  late String formattedDate = DateFormat(dayFormat).format(currentDate);

  Future fetchFeeds({bool? loadingNext,String? categoryId}) async {
    print("check vatgory if $categoryId");
    return await context.read<FeedsController>().fetchFeeds(
          context: context,
          isRefresh: loadingNext == true ? false : true,
          loadingNext: loadingNext ?? false,
          // categoryId: selectedFilter?.id??1,
          categoryId: categoryId,
          searchKey: 'searchController.text',
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchFeeds();
      await context.read<GuestControllers>().fetchFeedCategories(context: context);
      await context.read<CheckDemoController>().getStepCheckDemo(context: context);
    });
  }
  Future<void> _showDialog(
      BuildContext context,

      ) async {
    return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
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
            child:AlertBox()
          ),
        );
      },
    );

  }
  Set<int> selectedIds = Set<int>();

  @override
  Widget build(BuildContext context) {
    LocalDatabase localDatabase = Provider.of<LocalDatabase>(context);

    Size size = MediaQuery.of(context).size;
    return Consumer<FeedsController>(builder: (context, controller, child) {
      feeds = controller.feeds;
      return Scaffold(

        appBar: AppBar(
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome ${localDatabase.guest?.firstName.toCapitalizeFirst ?? 'Guest'}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: GoogleFonts.urbanist().fontFamily,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  GradientText(
                    formattedDate,
                    gradient: primaryGradient,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: GoogleFonts.urbanist().fontFamily,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )
            ],
          ),
          automaticallyImplyLeading: false,
          actions: const [
            ImageView(
              height: 24,
              width: 24,
              borderRadiusValue: 0,
              color: Colors.white,
              margin: EdgeInsets.only(left: 8, right: 8),
              fit: BoxFit.contain,
              assetImage: AppAssets.notificationsIcon,
            ),
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: bottomNavbarSize,left: 4,right: 4),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: 4,bottom: 8),
              child: Text(
                'Congratulations to the new joinees',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: GoogleFonts.urbanist().fontFamily,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const GuestProfiles(),



            const Banners(),
            Consumer<CheckDemoController>(
              builder: (context, controller, child) {
                return  GradientButton(
                  height: 70,
                  borderRadius: 18,
                  backgroundGradient: primaryGradient,
                  backgroundColor: Colors.transparent,
                  boxShadow: const [],
                  onTap: () {
                if(controller.getStep?.demoStep==6){
                  context.pushNamed(Routs.guestDemoVideos);
                }else{
                  context.pushNamed(Routs.guestCheckDemo).whenComplete(()async {
                    await context.read<CheckDemoController>().getStepCheckDemo(context: context);
                  },);

                }
                  },
                  margin: const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Yes, I want to change my life',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: GoogleFonts.urbanist().fontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              },


            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
            //   child: Container(
            //     // height:size.height*0.05 ,
            //     decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(AppAssets.container))),
            //     child: const Padding(
            //       padding: EdgeInsets.only(left: kPadding, right: kPadding, top: 5, bottom: 5),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           Text(
            //             'Total App Download',
            //             style: TextStyle(
            //               fontSize: 16,
            //               fontWeight: FontWeight.w700,
            //               color: Colors.black,
            //             ),
            //           ),
            //           Text(
            //             '10 K',
            //             style: TextStyle(
            //               fontSize: 32,
            //               fontWeight: FontWeight.w700,
            //               color: Colors.black,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
             CustomTextField(
              hintText: 'Search events, benefits, and more',
              controller: searchController,
              onFieldSubmitted: (value)async {
                await context.read<FeedsController>().fetchFeeds(
                  context: context,
                  isRefresh:  true ,
                  loadingNext:  false,
                  categoryId: '',
                  searchKey: searchController.text,
                );
              },
              hintStyle: const TextStyle(color: Colors.white),
              prefixIcon: const ImageView(
                height: 20,
                width: 20,
                borderRadiusValue: 0,
                color: Colors.white,
                margin: EdgeInsets.only(left: kPadding, right: kPadding),
                fit: BoxFit.contain,
                assetImage: AppAssets.searchIcon,
              ),
              margin: const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding, bottom: kPadding),
            ),
            // if (filters?.haveData == true)
            Padding(
              padding: const EdgeInsets.only(left: kPadding,right: kPadding),
              child: Consumer<GuestControllers>(
                builder: (context, value, child) {
                  return SizedBox(
                    height: 40,
                    child:
                    ListView.builder(
                      itemCount: value.fetchFeedCategoriesModel?.data?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                      // padding: const EdgeInsets.only(left: 20,),
                      itemBuilder: (context, index) {
                        var data = value.fetchFeedCategoriesModel?.data?.elementAt(index);
                        bool isSelected = selectedIds.contains(data?.id);
                        selectedFilter ??= data;
                        return GradientButton(
                          backgroundGradient: isSelected? primaryGradient : inActiveGradient,
                          borderWidth: 2,
                          borderRadius: 30,
                          onTap: () async{
                            selectedFilter = data;
                            if (isSelected) {
                              selectedIds.remove(data?.id);
                            } else {
                              selectedIds.add(int.parse(data?.id.toString()??''));
                            }

                            setState(() {});
                          await  fetchFeeds(categoryId:selectedIds.join(',') );
                          },
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 8),
                          child: Text(
                            '${data?.name}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.black : Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            if (controller.loadingFeeds)
              const LoadingScreen(
                heightFactor: 0.3,
                message: 'Loading Feeds...',
              )
            else if (feeds.haveData)
              ListView.builder(
                itemCount: feeds?.length ?? 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var data = feeds?.elementAt(index);
                  return InkWell(
                    onTap: () {
                      context.pushNamed(Routs.feedDetail, extra: FeedDetail(id: data?.id));
                    },
                    child: FeedCard(
                      index: index,
                      data: data,
                    ),
                  );
                },
              )
            else
              NoDataFound(
                heightFactor: 0.3,
                message: controller.feedsModel?.message ?? 'No Feeds Found',
              ),
          ],
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: size.height * 0.1),
          child: GestureDetector(
            onTap: () {
              launchUrl(Uri.parse('tel:9876543210'));
            },
            child: Container(
              decoration: BoxDecoration(gradient: primaryGradient, shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(kPadding),
                child: Image.asset(
                  AppAssets.call2,
                  height: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class AlertBox extends StatelessWidget {
  Color? inactiveColor =const Color(0xFF1C1C1C);

  AlertBox({

    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
      Center(child: Padding(
        padding: const EdgeInsets.all(13),
        child: Container(
          decoration:  BoxDecoration(
            color: inactiveColor,
            borderRadius: BorderRadius.circular(22)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomBackButton1(
                      padding:  const EdgeInsets.all(10),
                      icon: Icons.clear,
                      onTap: () {
                        context.pushNamed(Routs.guestCheckDemo).whenComplete(() {
                          context.pop();
                        },);
                      },
                    )
                  ],
                ),
                CustomeText(
                  text: 'DISCLAIMER',
                  fontSize: 34,
                  fontWeight: FontWeight.w500,
                ),
                CustomeText(
                  text: 'Remember, each body is different. Kangen does not claim that it cures any ailment.',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(
                  height: size.height*0.04,
                ),
                CustomeText(
                  text: 'Please read the disclaimer to proceed.',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
      ));
  }
}