import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/screens/guest/home/banners.dart';
import 'package:mrwebbeast/utils/widgets/custom_text_field.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:mrwebbeast/utils/widgets/gradient_text.dart';
import 'package:provider/provider.dart';

import '../../../controllers/auth_controller/auth_controller.dart';
import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../core/constant/gradients.dart';
import '../../../core/route/route_paths.dart';
import '../../../models/guest_Model/fetchnewjoiners.dart';
import '../../../utils/widgets/image_view.dart';
import 'guest_profiles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      await context.read<GuestControllers>().fetchFeedCategories(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                  'Welcome Guest',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: GoogleFonts.urbanist().fontFamily,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.start,
                ),
                GradientText(
                  'Monday, 12 Jan',
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
        padding: const EdgeInsets.only(bottom: bottomNavbarSize),
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: kPadding, right: kPadding, top: 6),
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
          GradientButton(
            height: 70,
            borderRadius: 18,
            backgroundGradient: primaryGradient,
            backgroundColor: Colors.transparent,
            boxShadow: const [],
            // margin:const EdgeInsets.only(left: 16, right: 24, bottom: 24),
            onTap: () {
              // context.pushNamed(Routs.verifyOTP);
            },
            margin: const EdgeInsets.only(
                left: kPadding, right: kPadding, top: kPadding),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Check Demo',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: GoogleFonts.urbanist().fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
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

          const CustomTextField(
            hintText: 'Search',
            readOnly: true,
            hintStyle: TextStyle(color: Colors.white),
            prefixIcon: ImageView(
              height: 20,
              width: 20,
              borderRadiusValue: 0,
              color: Colors.white,
              margin: EdgeInsets.only(left: kPadding, right: kPadding),
              fit: BoxFit.contain,
              assetImage: AppAssets.searchIcon,
            ),
            margin: EdgeInsets.only(
                left: kPadding,
                right: kPadding,
                top: kPadding,
                bottom: kPadding),
          ),
          // if (filters?.haveData == true)
          Consumer<GuestControllers>(
              builder: (context, value, child) {
                return SizedBox(
                  height: 40,
                  child: Center(
                    child: ListView.builder(
                      itemCount:value.fetchFeedCategoriesModel?.data?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: kPadding),
                      itemBuilder: (context, index) {

                        var data = value.fetchFeedCategoriesModel?.data?.elementAt(index);
                        // bool isSelected = selectedFilter == data;
                        return GradientButton(
                          backgroundGradient: value.tabIndex==index ? primaryGradient : inActiveGradient,
                          borderWidth: 2,
                          borderRadius: 30,
                          onTap: () {
                            setState(() {
                              value.tabIndex = index;
                            });
                          },
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: kPadding, vertical: 8),
                          child: Text(
                            '${data?.name}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: value.tabIndex==index ? Colors.black : Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },

            ),
          ListView.builder(
            itemCount: 8,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    context.pushNamed(Routs.productDetail);
                  },
                  child: FeedCard(index: index));
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: size.height * 0.1),
        child: Container(
          decoration:
              BoxDecoration(gradient: primaryGradient, shape: BoxShape.circle),
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
    );
  }
}

class FeedCard extends StatelessWidget {
  FeedCard({
    super.key,
    required this.index,
    this.imageHeight,
    this.fit,
    this.type,
    this.networkImage,
  });
  double? imageHeight;
  BoxFit? fit;
  String? type;
  String? networkImage;

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
      decoration: BoxDecoration(
        gradient: feedsCardGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageView(
            height: imageHeight,
            borderRadiusValue: 16,
            margin: const EdgeInsets.all(12),
            fit: fit ?? BoxFit.contain,
            networkImage: networkImage??'',
            // assetImage: AppAssets.product1,
          ),
          if (type != 'true')
          Padding(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Best water purifier: 10 picks to ensure clean drinking water',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
                if (type == 'true')
                  const SizedBox(
                    height: 10,
                  ),
                if (type != 'true')
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '12 hr',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                if (type != 'true')
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            FeedMenu(
                              icon: AppAssets.heartIcon,
                              value: '3',
                            ),
                            FeedMenu(
                              icon: AppAssets.chatIcon,
                              value: '12K',
                            ),
                            FeedMenu(
                              icon: AppAssets.shareIcon,
                            ),
                          ],
                        ),
                        FeedMenu(
                          lastMenu: true,
                          icon: AppAssets.bookmarkIcon,
                        ),
                      ],
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

class FeedMenu extends StatelessWidget {
  const FeedMenu({
    super.key,
    required this.icon,
    this.value,
    this.onTap,
    this.lastMenu,
  });

  final String icon;
  final String? value;
  final bool? lastMenu;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: lastMenu != true ? kPadding : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageView(
            height: 20,
            width: 20,
            borderRadiusValue: 0,
            color: Colors.white,
            margin: const EdgeInsets.only(right: 4),
            fit: BoxFit.contain,
            onTap: onTap,
            assetImage: icon,
          ),
          if (value != null)
            Text(
              '$value',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
            ),
        ],
      ),
    );
  }
}
