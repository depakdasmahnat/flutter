import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/member_auth_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/route/route_paths.dart';
import '../../../utils/widgets/web_view_screen.dart';
import '../web_view/faq.dart';

class GuestProfile extends StatefulWidget {
  const GuestProfile({super.key});

  @override
  State<GuestProfile> createState() => _GuestProfileState();
}

class _GuestProfileState extends State<GuestProfile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: size.height * 0.19,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage(AppAssets.getsprofile), fit: BoxFit.cover),
                  )),
              SizedBox(
                height: size.height * 0.04,
              ),
              const Text(
                'Ayaan Sha',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600, height: 1.3),
                textAlign: TextAlign.center,
              ),
              const Text(
                '+91 62656 84212',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400, height: 1.3),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Civil lines, Raipur, C.G.',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400, height: 1.2),
                textAlign: TextAlign.center,
              ),
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
                            context.push(Routs.guestEditProfile);
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        IconAndText(
                          icon: AppAssets.faq,
                          title: 'FAQ',
                          onTap: () {
                            context.pushNamed(Routs.webView,
                                extra: const WebViewScreen(url: 'https://api.gtp.proapp.in/api/v1/fetch_faqs',));
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
                          onTap: () {
                            context.pushNamed(Routs.webView,
                                extra: const WebViewScreen(url: 'https://api.gtp.proapp.in/api/v1/help_and_support',));
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        IconAndText(
                          icon: AppAssets.call,
                          title: 'Contact us',
                          onTap: () {

                            context.pushNamed(Routs.webView,
                                extra: const WebViewScreen(url: 'https://api.gtp.proapp.in/api/v1/contact_us',));
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        IconAndText(
                          icon: AppAssets.lockIcon,
                          title: 'Privacy policy ',
                          onTap: () {

                            context.pushNamed(Routs.webView,
                                extra: const WebViewScreen(url: 'https://api.gtp.proapp.in/api/v1/privacy_policy',));

                          },
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
          Positioned(
            top: size.height * 0.11,
            left: size.width * 0.37,
            child: CircleAvatar(
              minRadius: size.height * 0.06,
              maxRadius: size.height * 0.06,
              backgroundImage: const AssetImage(AppAssets.product1),
            ),
          )
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
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
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
