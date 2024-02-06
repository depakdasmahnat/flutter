import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/screens/guest/home/banners.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../core/constant/gradients.dart';
import '../../../models/member/dashboard/traning_progress_model.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/training_progress.dart';
import '../../guest/home/guest_profiles.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 8),
            child: Text(
              'Congratulations to the new joiners',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: GoogleFonts.urbanist().fontFamily,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          const GuestProfiles(),
          const Banners(),
          const TrainingProgress(),
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
                  context.pushNamed(Routs.demos);
                },
              ),
              MenuCard(
                image: AppAssets.resourcesIcon,
                name: 'Resources',
                onTap: () {
                  context.pushNamed(Routs.resources);
                },
              ),
              // MenuCard(
              //   image: AppAssets.eventIcon,
              //   name: 'Events',
              //   onTap: () {
              //     context.pushNamed(Routs.events);
              //   },
              // ),

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
              margin: const EdgeInsets.symmetric(horizontal: kPadding),
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
