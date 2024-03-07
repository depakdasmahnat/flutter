import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../controllers/dashboard/dashboard_controller.dart';
import '../../core/config/app_assets.dart';
import '../../core/constant/constant.dart';
import '../../core/route/route_paths.dart';
import '../../utils/widgets/training_progress.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      width: size.width * 0.85,
      backgroundColor: Colors.black,
      child: SafeArea(
        child: ListView(
          children: [
            const Row(
              children: [
                ImageView(
                  height: 40,
                  assetImage: AppAssets.logoHorizontalText,
                  margin: EdgeInsets.only(left: kPadding, top: kPadding, bottom: kPadding),
                  onTap: null,
                ),
              ],
            ),
            Divider(color: Colors.grey.shade700, thickness: 0),
            const TrainingProgress(margin: EdgeInsets.only(left: 8,right: 8),),
            Divider(color: Colors.grey.shade700, thickness: 0),
            CustomDrawerTile(
              activeImage: AppAssets.dashboardIcon,
              title: 'Dashboard',
              onTap: () {},
            ),
            CustomDrawerTile(
              activeImage: AppAssets.performanceIcon,
              title: 'Performance',
              onTap: () {
                context.pushNamed(Routs.performanceChart);
              },
            ),
            // CustomDrawerTile(
            //   activeImage: AppAssets.videoIcons,
            //   title: 'Demo',
            //   onTap: () {
            //     context.pushNamed(Routs.demos);
            //   },
            // ),
            CustomDrawerTile(
              activeImage: AppAssets.trainingIcon,
              title: 'Training',
              onTap: () {
                context.pushNamed(Routs.trainingScreen);
              },
            ),
            CustomDrawerTile(
              activeImage: AppAssets.goalIcon,
              title: 'Goal',
              onTap: () {
                context.pushNamed(Routs.goals);
              },
            ),
            CustomDrawerTile(
              activeImage: AppAssets.todoIcon,
              title: 'To Do',
              onTap: () {
                context.pushNamed(Routs.toDoScreen);
              },
            ),
            CustomDrawerTile(
              activeImage: AppAssets.targetIcon,
              title: 'Target',
              onTap: () {
                context.pushNamed(Routs.targetScreen);
              },
            ),
            CustomDrawerTile(
              activeImage: AppAssets.eventIcon,
              title: 'Events',
              onTap: () {
                context.pushNamed(Routs.events);
              },
            ),
            CustomDrawerTile(
              activeImage: AppAssets.feedsIcon,
              title: 'Social',
              // badgeCount: 45,
              onTap: () {
                context.pushNamed(Routs.memberFeeds);
              },
            ),
            CustomDrawerTile(
              activeImage: AppAssets.documentIcon,
              title: 'Reports',
              onTap: () {
                context.pushNamed(Routs.networkReport);
              },
            ),
            CustomDrawerTile(
              activeImage: AppAssets.resourcesIcon,
              title: 'Data Bank',
              onTap: () {
                context.pushNamed(Routs.resources);
              },
            ),
            // CustomDrawerTile(
            //   activeImage: AppAssets.hallOfFameIcon,
            //   title: 'Hall of fame',
            //   onTap: () {
            //     context.pushNamed(Routs.hallOfFame);
            //   },
            // ),
            CustomDrawerTile(
              activeImage: AppAssets.setting,
              title: 'Services',
              onTap: () {
                context.pushNamed(Routs.services);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDrawerTile extends StatelessWidget {
  final String? inActiveImage;
  final String activeImage;
  final String title;
  final int? badgeCount;

  final GestureTapCallback? onTap;

  const CustomDrawerTile({
    super.key,
    this.inActiveImage,
    required this.activeImage,
    required this.title,
    this.badgeCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardController>(builder: (context, controller, child) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          context.pop();
          onTap?.call();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding, bottom: kPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ImageView(
                    height: 24,
                    assetImage: activeImage,
                    color: Colors.white,
                    margin: const EdgeInsets.only(right: 24),
                    onTap: null,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (badgeCount != null)
                Badge(
                  backgroundColor: Colors.red,
                  smallSize: 16,
                  largeSize: 22,
                  label: Text(
                    '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
            ],
          ),
        ),
      );
    });
  }
}
