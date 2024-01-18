import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/constant/colors.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_string_extension.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/core/services/database/local_database.dart';
import 'package:mrwebbeast/core/services/localization/localization_controller.dart';
import 'package:mrwebbeast/core/services/theme/theme_controller.dart';
import 'package:provider/provider.dart';

import '../../../core/config/api_config.dart';
import '../../../core/config/app_config.dart';

import '../../../core/constant/shadows.dart';

import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/web_view_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  LocalDatabase localDatabase = LocalDatabase();
  double imageRadius = 70;

  late String? name = localDatabase.name ?? 'Sahil';
  late String? email = localDatabase.email;
  late String? profilePhoto = localDatabase.profilePhoto;
  double gaasCoin = 0;

  bool partnerRequested = false;
  bool isAuthenticated = LocalDatabase().accessToken != null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Provider.of<ThemeController>(context);
    LocalizationController localizationController = Provider.of<LocalizationController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
                decoration: BoxDecoration(
                  color: context.containerColor,
                  boxShadow: primaryBoxShadow(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    // context.push(Routs.editProfile);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name ?? 'User',
                            style: context.theme.textTheme.titleLarge,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              email ?? AppConfig.contactEmail,
                              style: context.theme.textTheme.titleSmall,
                            ),
                          ),
                        ],
                      ),
                      ImageView(
                        height: imageRadius,
                        width: imageRadius,
                        borderRadiusValue: imageRadius,
                        networkImage: profilePhoto,
                        isAvatar: true,
                        fullScreenMode: true,
                        fit: BoxFit.cover,
                        border: Border.all(color: primaryColor.withOpacity(0.2)),
                        margin: const EdgeInsets.only(left: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              color: context.containerColor,
              boxShadow: primaryBoxShadow(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                SettingButton(
                  icon: Icons.person_outline_rounded,
                  text: 'Edit Profile',
                  onClick: () {
                    context.push(Routs.editProfile);
                  },
                ),
                SettingButton(
                  icon: Icons.color_lens_outlined,
                  text: 'Change Theme',
                  trailingText: themeController.themeMode.name.toCapitalizeFirst,
                  onClick: () {
                    themeController.showThemePicker(context: context);
                  },
                ),
                SettingButton(
                  icon: CupertinoIcons.globe,
                  text: 'Change Language',
                  trailingText: '${context.localizations?.nativeLanguageName} ',
                  onClick: () {
                    localizationController.showLanguagePicker(context: context);
                  },
                ),
                SettingButton(
                  icon: Icons.security_outlined,
                  text: 'Permissions',
                  onClick: () {},
                ),
                SettingButton(
                  icon: Icons.info_outline,
                  text: 'Report & Feedback',
                  onClick: () {},
                ),
                SettingButton(
                  icon: CupertinoIcons.person_2,
                  text: 'About Us',
                  onClick: () {
                    context.pushNamed(Routs.aboutUs);
                  },
                ),
                SettingButton(
                  icon: CupertinoIcons.doc_on_doc,
                  text: 'Terms & Conditions',
                  showDivider: false,
                  onClick: () {
                    context.pushNamed(Routs.webView,
                        extra: const WebViewScreen(
                          title: 'Terms & Conditions',
                          url: ApiConfig.termsAndConditionsUrl,
                        ));
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              color: context.containerColor,
              boxShadow: primaryBoxShadow(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SettingButton(
              icon: Icons.policy_outlined,
              text: 'Privacy Policy',
              showDivider: false,
              onClick: () {
                context.pushNamed(Routs.webView,
                    extra: const WebViewScreen(
                      title: 'Privacy Policy',
                      url: ApiConfig.privacyPolicyUrl,
                    ));
              },
            ),
          ),
          if (localDatabase.accessToken != null)
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                color: context.containerColor,
                boxShadow: primaryBoxShadow(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SettingButton(
                icon: Icons.logout,
                text: 'Logout',
                onClick: () {
                  // context.read<AuthControllers>().signOut(context: context);
                },
                showDivider: false,
              ),
            )
          else
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                color: context.containerColor,
                boxShadow: primaryBoxShadow(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SettingButton(
                icon: Icons.login,
                text: 'Sign In',
                onClick: () {
                  LocalDatabase().database.clear().then((value) {
                    context.pushReplacement(Routs.login);
                  });
                },
                showDivider: false,
              ),
            ),
        ],
      ),
    );
  }
}

class SettingButton extends StatelessWidget {
  const SettingButton({
    Key? key,
    this.image,
    this.icon,
    required this.text,
    required this.onClick,
    this.dividerThickness,
    this.trailingText,
    this.dividerPadding,
    this.showDivider = true,
  }) : super(key: key);

  final String? image;
  final IconData? icon;
  final String text;
  final GestureTapCallback onClick;
  final String? trailingText;
  final bool? showDivider;
  final double? dividerThickness;
  final double? dividerPadding;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onClick,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 6,
                  child: Row(
                    children: [
                      icon != null
                          ? Icon(
                              icon,
                              size: 20,
                              color: context.colorScheme.primary,
                            )
                          : ImageView(
                              height: 20,
                              width: 20,
                              fit: BoxFit.cover,
                              borderRadiusValue: 0,
                              color: context.colorScheme.primary,
                              margin: EdgeInsets.zero,
                              assetImage: image,
                              onTap: null,
                            ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            text,
                            style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (trailingText != null)
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Text(
                              '$trailingText',
                              style: context.textTheme.labelMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: context.colorScheme.primary,
                        size: 16,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Divider(
                height: 0,
                color: showDivider == true ? null : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
