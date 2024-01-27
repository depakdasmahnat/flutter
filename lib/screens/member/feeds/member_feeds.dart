import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/screens/member/feeds/feeds_card.dart';
import 'package:mrwebbeast/utils/widgets/custom_text_field.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';

import '../../../core/constant/gradients.dart';
import '../../../core/route/route_paths.dart';
import '../../../models/feeds/feeds_model.dart';
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
          if (dummyFeedsList.haveData)
            ListView.builder(
              itemCount: dummyFeedsList.length ?? 0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    context.pushNamed(Routs.productDetail);
                  },
                  child: FeedCard(
                    index: index,
                    data: dummyFeedsList.elementAt(index),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

List<FeedsData> dummyFeedsList = [
  FeedsData(
    id: '1',
    title: 'Best water purifier: 10 picks to ensure clean drinking water',
    duration: '5:30',
    likes: 150,
    comments: 25,
    wishlistId: 'w123',
    isLiked: false,
    isBookmarked: true,
    images: [
      AppAssets.product1,
      AppAssets.product2,
    ],
    videoUrl: null,
    youtubeUrl: null,
    share: 'https://example.com/share/1',
  ),
  FeedsData(
    id: '2',
    title: 'Exciting Adventure',
    duration: '8:45',
    likes: 300,
    comments: 40,
    wishlistId: 'w456',
    isLiked: true,
    isBookmarked: false,
    images: null,
    videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    youtubeUrl: null,
    share: 'https://example.com/share/2',
  ),
  FeedsData(
    id: '3',
    title: 'Exciting Adventure',
    duration: '8:45',
    likes: 300,
    comments: 40,
    wishlistId: 'w456',
    isLiked: true,
    isBookmarked: false,
    images: null,
    videoUrl: null,
    youtubeUrl: 'https://www.youtube.com/watch?v=6GL4kW_llds',
    share: 'https://example.com/share/2',
  ),
];
