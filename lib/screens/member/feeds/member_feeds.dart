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

import '../../../core/constant/gradients.dart';
import '../../../core/route/route_paths.dart';
import '../../../utils/widgets/image_view.dart';

class MemberFeeds extends StatefulWidget {
  const MemberFeeds({
    super.key,
  });

  @override
  State<MemberFeeds> createState() => _MemberFeedsState();
}

class _MemberFeedsState extends State<MemberFeeds> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  String? selectedFilter = 'Trending';
  List<String>? filters = [
    'Trending',
    'Products',
    'Today',
    'Technology',
    'Water',
    'Filter',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Feeds'),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: bottomNavbarSize),
        children: [
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
            margin: EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
          ),
          if (filters?.haveData == true)
            SizedBox(
              height: 40,
              child: Center(
                child: ListView.builder(
                  itemCount: filters?.length ?? 0,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: kPadding),
                  itemBuilder: (context, index) {
                    var data = filters?.elementAt(index);

                    bool isSelected = selectedFilter == data;
                    return GradientButton(
                      backgroundGradient: isSelected ? primaryGradient : inActiveGradient,
                      borderWidth: 2,
                      borderRadius: 30,
                      onTap: () {
                        setState(() {
                          selectedFilter = data;
                        });
                      },
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 8),
                      child: Text(
                        '$data',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.black : Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
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
  });

  double? imageHeight;
  BoxFit? fit;
  String? type;

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
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
            assetImage: AppAssets.product1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
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
