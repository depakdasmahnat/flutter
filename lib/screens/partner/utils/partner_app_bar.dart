import 'package:flutter/material.dart';
import 'package:gaas/screens/notifications/notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controllers/partner/partner_controller.dart';
import '../../../core/config/app_images.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/widgets.dart';

AppBar partnerAppBar({
  required BuildContext context,
  required String? title,
  Color? backgroundColor,
  Color? iconColor,
  GestureTapCallback? onBackPress,
  GestureTapCallback? onNotificationClick,
  List<Widget>? actions,
}) {
  return AppBar(
    leadingWidth: 100,
    backgroundColor: backgroundColor,
    leading: Row(
      children: [
        backButton(
            context: context,
            onTap: onBackPress ??
                () async {
                  context.read<PartnerController>().onPartnerBackPress(context);
                }),
        ImageView(
          assetImage: AppImages.appIcon,
          height: 38,
          width: 38,
          color: iconColor,
          margin: const EdgeInsets.only(left: 8),
        ),
      ],
    ),
    title: Text(
      "$title",
      style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
    ),

    actions: actions ??
        <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: iconColor ?? Colors.black,
            ),
            tooltip: 'Notifications',
            onPressed: onNotificationClick ??
                () {
                  String partnerType = context.read<PartnerController>().serviceType.value;
                  context.pushNamed(Routs.notifications,
                      extra: NotificationScreen(
                        partnerType: partnerType,
                      ));
                },
          ), //IconButton
        ], //<Widget>[]
  );
}
