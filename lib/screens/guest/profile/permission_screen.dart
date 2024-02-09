import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/services/notifications/notification_controller.dart';
import 'package:provider/provider.dart';

import '../../../core/constant/colors.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/widgets.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({Key? key}) : super(key: key);

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> with WidgetsBindingObserver {
  Future manageNotificationPermission({
    bool? forceRequest,
    bool? checkOnly,
  }) async {
    NotificationController notificationController =
        Provider.of<NotificationController>(context, listen: false);
    await notificationController.manageNotificationPermission(
      context: context,
      forceRequest: forceRequest ?? false,
      checkOnly: checkOnly ?? false,
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      manageNotificationPermission();
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('App lifecycle state changed: $state');
    manageNotificationPermission(checkOnly: true);
  }

  @override
  Widget build(BuildContext context) {
    NotificationController notificationController = Provider.of<NotificationController>(context);
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Preference'),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: size.height * 0.1),
        physics: const BouncingScrollPhysics(),
        children: [
          headingText(
            text: 'Permissions'.toUpperCase(),
            color: Colors.grey.shade600,
            fontSize: 14,
            padding: const EdgeInsets.only(left: 16, top: 24, right: 16, bottom: 8),
            context: context,
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                profileButton(
                  icon: Icons.notifications_active,
                  title: 'Notifications',
                  description: 'Never miss and important update.',
                  onClick: () {},
                  trailing: CupertinoSwitch(
                    value: notificationController.haveNotificationPermission ?? false,
                    onChanged: (val) {
                      notificationController.manageNotificationPermission(
                        context: context,
                        removePermission: !val,
                        forceRequest: true,
                      );
                    },
                  ),
                  showDivider: true,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget profileButton({
    String? image,
    IconData? icon,
    required String title,
    String? description,
    bool? showDivider = true,
    double? dividerThickness,
    double? dividerPadding,
    Widget? trailing,
    required GestureTapCallback onClick,
  }) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          icon != null
                              ? Icon(
                                  icon,
                                  size: 28,
                                  color: primaryColor,
                                )
                              : ImageView(
                                  height: 28,
                                  width: 28,
                                  fit: BoxFit.cover,
                                  borderRadiusValue: 0,
                                  color: primaryColor,
                                  margin: EdgeInsets.zero,
                                  assetImage: image,
                                  onTap: null,
                                ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14, right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              if (description != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    description,
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    trailing ??
                        const Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                  ],
                )
              ],
            ),
            if (showDivider == true)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Divider(
                  height: 0,
                  color: Colors.grey.shade300,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
