import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/utils/widgets/custom_text_field.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';

import '../../../core/constant/gradients.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../../../utils/widgets/image_view.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({
    super.key,
  });

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
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
        leading:  CustomBackButton(),
        title: const Text('Goals'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(kPadding),
            child: GestureDetector(
              onTap: () {
                context.pushNamed(Routs.createGoal);
              },
              child: DottedBorder(
                dashPattern: const [4, 4],
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                color: Colors.grey,
                child: Container(
                  height: 50,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          gradient: blackGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.add),
                      ),
                      const Text(
                        'Add a new goal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                  child: GoalCard(
                    index: index,
                    title: 'Luxury House',
                    description:
                        'Reference site about Lorem Ipsum, giving information on its origins, as well as a random Lipsum generator.',
                    startDate: '14 Jan, 2024',
                    endDate: '28 Jan, 2024',
                    status: 'Achieved',
                    type: 'Family',
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

class GoalCard extends StatelessWidget {
  final double? imageHeight;
  final BoxFit? fit;

  final int index;
  final String? title;

  final String? description;
  final String? startDate;
  final String? endDate;
  final String? type;
  final String? status;

  const GoalCard(
      {super.key,
      this.imageHeight,
      this.fit,
      required this.index,
      required this.title,
      required this.description,
      required this.startDate,
      required this.endDate,
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
            assetImage: AppAssets.goalImage,
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
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  child: Text(
                    description ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      FeedMenu(
                        icon: AppAssets.eventIcon,
                        value: startDate ?? '',
                      ),
                      FeedMenu(
                        icon: AppAssets.membersIcon,
                        value: type ?? '',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Expected completion date: ${endDate ?? ' '}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                GradientButton(
                  height: 40,
                  borderRadius: 50,
                  backgroundGradient: whiteGradient,
                  margin: const EdgeInsets.symmetric(vertical: kPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$status',
                        style: const TextStyle(color: Colors.black),
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
