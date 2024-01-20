import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/screens/guest/home/banners.dart';
import 'package:mrwebbeast/utils/widgets/custom_text_field.dart';
import 'package:mrwebbeast/utils/widgets/gradient_text.dart';
import 'package:provider/provider.dart';

import '../../../core/constant/gradients.dart';
import '../../../guest/home/guest_profiles.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/gradient_progress_bar.dart';
import '../../../utils/widgets/image_view.dart';

class MemberHomeScreen extends StatefulWidget {
  const MemberHomeScreen({
    super.key,
  });

  @override
  State<MemberHomeScreen> createState() => _MemberHomeScreenState();
}

class _MemberHomeScreenState extends State<MemberHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  List<String> banners = [
    AppAssets.banner,
    AppAssets.banner1,
    AppAssets.banner2,
  ];

  double? trainingProgress = 75;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: bottomNavbarSize),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: 6),
            child: Text(
              'Congratulations to the new joiners',
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
          Banners(banners: banners),
          GestureDetector(
            onTap: () {
              context.pushNamed(Routs.demoVideos);
            },
            child: Container(
              margin: const EdgeInsets.only(top: kPadding, left: kPadding, right: kPadding, bottom: 8),
              padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Training Progress',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GradientProgressBar(
                    value: (trainingProgress ?? 0) > 0 ? (trainingProgress! / 100) : 0,
                    backgroundColor: Colors.grey.shade300,
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Steps 35/60',
                        style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${(trainingProgress ?? 0).toStringAsFixed(0)}%',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Compete your training',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GridView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(kPadding),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            children: [
              MenuCard(
                image: AppAssets.dashboardIcon,
                name: 'Dashboard',
                onTap: () {
                  context.pushNamed(Routs.memberDashBoard);
                },
              ),
              MenuCard(
                image: AppAssets.targetIcon,
                name: 'Target',
                onTap: () {
                  context.pushNamed(Routs.targetScreen);
                },
              ),
              MenuCard(
                image: AppAssets.goalIcon,
                name: 'Goal',
                onTap: () {
                  context.pushNamed(Routs.goals);
                },
              ),
              MenuCard(
                image: AppAssets.feedsIcon,
                name: 'Feeds',
                onTap: () {
                  context.pushNamed(Routs.memberFeeds);
                },
              ),
              MenuCard(
                image: AppAssets.todoIcon,
                name: 'To Do',
                onTap: () {
                  context.pushNamed(Routs.toDoScreen);
                },
              ),
              MenuCard(
                image: AppAssets.documentIcon,
                name: 'Reports',
                onTap: () {
                  context.pushNamed(Routs.networkReport);
                },
              ),
              MenuCard(
                image: AppAssets.achieversIcon,
                name: 'Achievers',
                onTap: () {
                  context.pushNamed(Routs.achievers);
                },
              ),

              MenuCard(
                image: AppAssets.videoIcons,
                name: 'Demo',
                onTap: () {
                  context.pushNamed(Routs.demoVideos);
                },
              ),

              MenuCard(
                image: AppAssets.resourcesIcon,
                name: 'Resources',
                onTap: () {
                  context.pushNamed(Routs.memberProfileDetails);
                },
              ),

              // MenuCard(
              //   image: AppAssets.trainingIcon,
              //   name: 'Training',
              //   onTap: () {
              //     context.pushNamed(Routs.trainingScreen);
              //   },
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.image,
    required this.name,
    this.onTap,
  });

  final String? image;
  final String? name;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: feedsCardGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageView(
              height: 30,
              width: 30,
              borderRadiusValue: 0,
              margin: const EdgeInsets.all(12),
              fit: BoxFit.contain,
              assetImage: '$image',
            ),
            Text(
              '$name',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
