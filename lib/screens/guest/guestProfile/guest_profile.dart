import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:image_picker/image_picker.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_string_extension.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../controllers/guest_controller/guest_controller.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/config/app_config.dart';
import '../../../core/route/route_paths.dart';
import '../../../core/services/database/local_database.dart';

import '../../../utils/widgets/widgets.dart';


class GuestProfile extends StatefulWidget {
  const GuestProfile({super.key});

  @override
  State<GuestProfile> createState() => _GuestProfileState();
}

class _GuestProfileState extends State<GuestProfile> {
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<GuestControllers>().fetchGuestProfile(
            context: context,
          );
    });
    super.initState();
  }

  File? image;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LocalDatabase localDatabase = Provider.of<LocalDatabase>(context);
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                  height: size.height * 0.19,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          AppAssets.getsprofile,
                        ),
                        fit: BoxFit.cover),
                  )),
              SizedBox(
                height: size.height * 0.04,
              ),
              Text(
                '${localDatabase.guest?.firstName.toCapitalizeFirst ?? ''} ${localDatabase.guest?.lastName.toCapitalizeFirst ?? ''}',
                style: const TextStyle(
                    color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600, height: 1.3),
                textAlign: TextAlign.center,
              ),
              Text(
                '+91 ${localDatabase.guest?.mobile ?? ''}',
                style: const TextStyle(
                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400, height: 1.3),
                textAlign: TextAlign.center,
              ),
              if (localDatabase.guest?.email != null)
                Text(
                  localDatabase.guest?.email ?? '',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400, height: 1.2),
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
                            context.push(Routs.guestEditProfile).whenComplete(
                              () async {
                                await context.read<GuestControllers>().fetchGuestProfile(
                                      context: context,
                                    );
                              },
                            );
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        IconAndText(
                          icon: AppAssets.profileStar,
                          title: 'Hall of fame',

                          onTap: () {
                            context.pushNamed(Routs.hallOfFame);
                            // context.push(Routs.guestEditProfile).whenComplete(
                            //       () async {
                            //     await context.read<GuestControllers>().fetchGuestProfile(
                            //       context: context,
                            //     );
                            //   },
                            // );
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
                            // context.pushNamed(Routs.webView,
                            //     extra: const WebViewScreen(
                            //       url: 'https://api.gtp.proapp.in/api/v1/fetch_faqs',
                            //     ));
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        IconAndText(
                          onTap: () {
                            context.pushNamed(Routs.guestNotification);
                          },
                          icon: AppAssets.notificationsIcon,
                          title: 'Notification ',
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        IconAndText(
                          icon: AppAssets.setting,
                          title: 'Setting',
                          onTap: () {
                            context.pushNamed(Routs.settings);
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        IconAndText(
                          icon: AppAssets.shareIcon,
                          title: 'Share App',
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
                            context.pushNamed(Routs.privacyPolicy);
                            // context.pushNamed(Routs.webView,
                            //     extra: const WebViewScreen(
                            //       url: 'https://api.gtp.proapp.in/api/v1/privacy_policy',
                            //     ));
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        IconAndText(
                          icon: AppAssets.feedBack,
                          title: 'Feedback',
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

            ],
          ),
          Positioned(
            top: size.height * 0.11,
            left: size.width * 0.37,
            child: Consumer<GuestControllers>(
              builder: (context, controller, child) {
                return GestureDetector(
                  onTap: () {
                    // addImages();
                  },
                  child: ImageView(
                    height: 100,
                    width: 100,
                    networkImage: controller.fetchGuestProfileModel?.data?.profilePhoto,
                    isAvatar: true,
                    borderRadiusValue: 50,
                    fit: BoxFit.cover,
                    margin: EdgeInsets.zero,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> updateProfileImage({required ImageSource source}) async {
    final pickedImg = await ImagePicker().pickImage(source: source);
    setState(() {
      if (pickedImg != null) {
        image = File(pickedImg.path);
      }
    });
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future addImages() async {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
                topLeft: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Change Profile Pic',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        updateProfileImage(source: ImageSource.camera);
                      },
                      child: pickImageButton(
                        context: context,
                        text: 'Camera',
                        icon: Icons.camera,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        updateProfileImage(source: ImageSource.gallery);
                      },
                      child: pickImageButton(
                        context: context,
                        text: 'Gallery',
                        icon: Icons.photo,
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
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
