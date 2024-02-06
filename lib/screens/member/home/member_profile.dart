import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/screens/member/invite/invite_leads_card.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:mrwebbeast/utils/widgets/training_progress.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/member_auth_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/gradients.dart';
import '../../../core/route/route_paths.dart';
import '../../../core/services/database/local_database.dart';
import '../../../utils/widgets/image_view.dart';

class MemberProfile extends StatefulWidget {
  const MemberProfile({super.key});

  @override
  State<MemberProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  double trainingProgress = 56;

  @override
  Widget build(BuildContext context) {
    LocalDatabase localDatabase = Provider.of<LocalDatabase>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
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
                          child: const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Text(
                                  '6A2',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                                ),
                              ),
                              ImageView(
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
                          child: const Row(
                            children: [
                              ImageView(
                                height: 14,
                                assetImage: AppAssets.membersFilledIcon,
                                margin: EdgeInsets.only(),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  'Members 54',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
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
          GradientButton(
            margin: const EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
            padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
            borderWidth: 2,
            gradient: primaryGradient,
            backgroundGradient: inActiveGradient,
            borderRadius: 16,
            child: Row(
              children: [
                const Column(
                  children: [
                    Padding(
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
                        ImageView(
                          height: 45,
                          width: 45,
                          assetImage: AppAssets.achievementIcon,
                          margin: EdgeInsets.only(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            '6A2',
                            style: TextStyle(
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
                Expanded(
                  child: Container(
                    height: 80,
                    margin: const EdgeInsets.only(left: kPadding),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(left: kPadding),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(right: kPadding),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text(
                                  '6A2',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              ImageView(
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
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    IconAndText(
                      icon: AppAssets.setting,
                      title: 'Setting ',
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    IconAndText(
                      icon: AppAssets.shareIcon,
                      title: 'Share App ',
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
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    IconAndText(
                      icon: AppAssets.call,
                      title: 'Contact us',
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    IconAndText(
                      icon: AppAssets.lockIcon,
                      title: 'Privacy policy ',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
            child: GestureDetector(
              onTap: () {
                context.read<MemberAuthControllers>().logOutPopup(context);
              },
              child: Card(
                type: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: kPadding, bottom: kPadding),
                  child: IconAndText(
                    icon: AppAssets.logout,
                    title: 'Sign Out',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
