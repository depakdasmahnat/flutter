import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/controllers/member/member_controller/member_controller.dart';
import 'package:mrwebbeast/core/config/app_config.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/screens/member/invite/invite_leads_card.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:mrwebbeast/utils/widgets/training_progress.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../controllers/member/member_auth_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/gradients.dart';
import '../../../core/route/route_paths.dart';
import '../../../core/services/database/local_database.dart';
import '../../../models/member/dashboard/achievement_badges_model.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/social_links.dart';
import '../../../utils/widgets/web_view_screen.dart';
import '../../guest/guestProfile/guest_faq.dart';
import '../../guest/guestProfile/guest_profile.dart';

class MemberProfile extends StatefulWidget {
  const MemberProfile({super.key});

  @override
  State<MemberProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  double trainingProgress = 56;
  TextEditingController searchController = TextEditingController();

  AchievementBadgesModel? achievementBadges;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<MembersController>().fetchAchievementBadges();
    });
  }

  @override
  Widget build(BuildContext context) {
    LocalDatabase localDatabase = Provider.of<LocalDatabase>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Consumer<MembersController>(builder: (context, controller, child) {
        achievementBadges = controller.achievementBadges;
        return ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageView(
                  height: 80,
                  width: 80,
                  border: Border.all(color: Colors.grey),
                  borderRadiusValue: 50,
                  isAvatar: true,
                  margin: const EdgeInsets.only(left: 8, right: 16),
                  fit: BoxFit.cover,
                  networkImage: '${localDatabase.member?.profilePhoto}',
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${localDatabase.member?.firstName} ${localDatabase.member?.lastName ?? ''}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 8),
                      child: Text(
                        'ID: ${localDatabase.member?.enagicId}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ),
                    if (localDatabase.member?.mobile != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          '+91 ${localDatabase.member?.mobile}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ),
                    if (localDatabase.member?.address != null)
                      Text(
                        '${localDatabase.member?.address}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: kPadding, right: kPadding),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: kPadding, bottom: 8),
                        child: Text(
                          'Achievement',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: inActiveGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                if (achievementBadges != null)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Text(
                                      achievementBadges?.currentTarget ?? '--',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                const ImageView(
                                  height: 18,
                                  assetImage: AppAssets.achievementIcon,
                                  margin: EdgeInsets.only(),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: kPadding),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: inActiveGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const ImageView(
                                  height: 14,
                                  assetImage: AppAssets.membersFilledIcon,
                                  margin: EdgeInsets.only(),
                                ),
                                if (achievementBadges != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      'Members ${achievementBadges?.members ?? 0}',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (achievementBadges != null)
              GradientButton(
                margin: const EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
                padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
                borderWidth: 2,
                gradient: primaryGradient,
                backgroundGradient: inActiveGradient,
                borderRadius: 16,
                child: Row(
                  children: [
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8, bottom: 8),
                          child: Text(
                            'Achievements',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const ImageView(
                              height: 45,
                              width: 45,
                              assetImage: AppAssets.achievementIcon,
                              margin: EdgeInsets.only(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                achievementBadges?.currentTarget ?? '',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (achievementBadges?.achievedBadges.haveData == true)
                      Expanded(
                        child: Container(
                          height: 80,
                          margin: const EdgeInsets.only(left: kPadding),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListView.builder(
                            itemCount: achievementBadges?.achievedBadges?.length ?? 0,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(left: kPadding),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var data = achievementBadges?.achievedBadges?.elementAt(index);

                              return Padding(
                                padding: const EdgeInsets.only(right: kPadding),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        '$data',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const ImageView(
                                      height: 24,
                                      width: 24,
                                      assetImage: AppAssets.achievementIcon,
                                      margin: EdgeInsets.only(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            const TrainingProgress(),
            const InviteLeadsCard(),
            Padding(
              padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
              child: Card(
                type: true,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: kPadding, bottom: kPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconAndText(
                        icon: AppAssets.edit,
                        title: 'Profile Edit',
                        onTap: () {
                          context.push(Routs.memberEditProfile);
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      IconAndText(
                        icon: AppAssets.hallOfFameIcon,
                        title: 'Hall of fame',
                        onTap: () {
                          context.push(Routs.hallOfFame);
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      IconAndText(
                        icon: AppAssets.faq,
                        title: 'FAQ',
                        onTap: () {
                          context.pushNamed(Routs.guestFaq);
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      IconAndText(
                        icon: AppAssets.notificationsIcon,
                        title: 'Notification ',
                        onTap: () {
                          context.pushNamed(Routs.guestNotification);
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      IconAndText(
                        icon: AppAssets.setting,
                        title: 'Setting ',
                        onTap: () {
                          context.pushNamed(Routs.settings);
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      IconAndText(
                        icon: AppAssets.shareIcon,
                        title: 'Share App ',
                        onTap: () {
                          Share.share(AppConfig.shareApp);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
              child: Card(
                type: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: kPadding, bottom: kPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconAndText(
                        icon: AppAssets.membersIcon,
                        title: 'Help & Support',
                        height: size.height * 0.021,
                        onTap: () {
                          context.pushNamed(Routs.helpAndSupport);
                          // context.pushNamed(Routs.webView,
                          //     extra: const WebViewScreen(
                          //       url: 'https://api.gtp.proapp.in/api/v1/help_and_support',
                          //     ));
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      IconAndText(
                        icon: AppAssets.termsAndCon,
                        title: 'Terms & conditions',
                        height: size.height * 0.024,
                        onTap: () {
                          // context.pushNamed(Routs.helpAndSupport);
                          context.pushNamed(Routs.webView,
                              extra: const WebViewScreen(
                                title: 'Terms & conditions',
                                url: 'https://api.gtp.proapp.in/api/v1/terms_and_condition',
                              ));
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      // IconAndText(
                      //   icon: AppAssets.call,
                      //   title: 'Contact us',
                      //   onTap: () {
                      //     context.pushNamed(Routs.webView,
                      //         extra: const WebViewScreen(
                      //           url: 'https://api.gtp.proapp.in/api/v1/contact_us',
                      //         ));
                      //   },
                      // ),
                      // SizedBox(
                      //   height: size.height * 0.02,
                      // ),
                      IconAndText(
                        icon: AppAssets.lockIcon,
                        title: 'Privacy policy ',
                        onTap: () {
                          // context.pushNamed(Routs.privacyPolicy);
                          context.pushNamed(Routs.webView,
                              extra: const WebViewScreen(
                                title: 'Privacy policy',
                                url: 'https://api.gtp.proapp.in/api/v1/privacy_policy',
                              ));
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      IconAndText(
                        icon: AppAssets.feedBack,
                        title: ' Feedback',
                        onTap: () {
                          context.pushNamed(Routs.feedbackAndRating);
                          // context.pushNamed(Routs.webView,
                          //     extra: const WebViewScreen(
                          //       url: 'https://api.gtp.proapp.in/api/v1/privacy_policy',
                          //     ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const FollowUsCard(
              padding: EdgeInsets.symmetric(horizontal: 24),
            ),
          ],
        );
      }),
    );
  }
}

class Card extends StatelessWidget {
  Widget? child;
  bool? type;

  Card({
    this.child,
    this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // width: 398,
      // height: 232,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.00, -1.00),
          end: const Alignment(0, 1),
          colors: type == true
              ? [const Color(0xFF3B3B3B), const Color(0xFF4A4A4A)]
              : [const Color(0xFF1B1B1B), const Color(0xFF282828)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 28.40,
            offset: Offset(0, 2),
            spreadRadius: 0,
          )
        ],
      ),
      child: child,
    );
  }
}

class IconAndText extends StatelessWidget {
  String? icon;
  String? title;
  double? height;
  void Function()? onTap;

  IconAndText({
    this.icon,
    this.title,
    this.onTap,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(icon ?? '', height: height ?? size.height * 0.026, fit: BoxFit.contain),
          SizedBox(
            width: size.width * 0.04,
          ),
          Text(
            title ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
