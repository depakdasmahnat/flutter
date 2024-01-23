import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';

import '../../../core/constant/gradients.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({
    super.key,
  });

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const CustomBackButton(),
        title: const Text('Events'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: kPadding,
              top: kPadding,
            ),
            child: Row(
              children: [
                Text(
                  'Upcoming Events',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Flexible(
                child: CustomTextField(
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
                  margin: EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding, bottom: kPadding),
                ),
              ),
              GradientButton(
                height: 60,
                width: 60,
                margin: const EdgeInsets.only(left: 8, right: kPadding),
                backgroundGradient: blackGradient,
                child: const ImageView(
                  height: 28,
                  width: 28,
                  assetImage: AppAssets.filterIcons,
                  margin: EdgeInsets.zero,
                ),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 8,
              padding: const EdgeInsets.only(bottom: bottomNavbarSize),
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // context.pushNamed(Routs.productDetail);
                  },
                  child: EventCard(
                    index: index,
                    title: 'Goal For Luxury House',
                    date: '14 Jan, 2024',
                    time: '07:35 PM',
                    status: 'Achieved',
                    type: 'Webinar',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final double? imageHeight;
  final BoxFit? fit;

  final int index;
  final String? title;

  final String? date;
  final String? time;
  final String? type;
  final String? status;

  const EventCard(
      {super.key,
      this.imageHeight,
      this.fit,
      required this.index,
      required this.title,
      required this.date,
      required this.time,
      required this.type,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
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
            assetImage: AppAssets.banner,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: kPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          FeedMenu(
                            icon: AppAssets.eventIcon,
                            value: date ?? '',
                          ),
                          FeedMenu(
                            icon: AppAssets.clockIcon,
                            value: time ?? '',
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Type of Events: ${type ?? ' '}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
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
            height: 16,
            width: 16,
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
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
        ],
      ),
    );
  }
}
