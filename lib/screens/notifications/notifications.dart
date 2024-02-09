import 'package:flutter/material.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:gaas/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../controllers/notifications/notifications_api_controller.dart';
import '../../models/notifications/notifications_model.dart';
import '../../utils/widgets/loading_screen.dart';
import '../../utils/widgets/no_data_screen.dart';
import '../../utils/widgets/widgets.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, this.partnerType}) : super(key: key);
  final String? partnerType;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late String? partnerType = widget.partnerType;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      NotificationsAPIController controller = Provider.of<NotificationsAPIController>(context, listen: false);
      controller.fetchAllNotifications(context: context, isRefresh: true, partnerType: partnerType);
    });
  }

  NotificationsModel? notificationsModel;
  List<NotificationsData>? notificationsData;

  @override
  Widget build(BuildContext context) {
    NotificationsAPIController controller = Provider.of<NotificationsAPIController>(context);
    notificationsModel = controller.notificationsModel;
    notificationsData = controller.notificationsData;
    return Scaffold(
      appBar: AppBar(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            backButton(context: context),
          ],
        ),
        leadingWidth: 50,
        centerTitle: true,
        title: const Text("Notifications"),
      ),
      body: SmartRefresher(
        controller: controller.notificationController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: () async {
          if (mounted) {
            await controller.fetchAllNotifications(isRefresh: true, context: context);
          }
        },
        onLoading: () async {
          if (mounted) {
            await controller.fetchAllNotifications(loadingNext: true, context: context);
          }
        },
        child: controller.loadingNotifications
            ? const LoadingScreen(
                heightFactor: 0.9,
                message: "Loading Notifications",
              )
            : (notificationsData?.isNotEmpty == true && notificationsData != null)
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: notificationsData?.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      var data = notificationsData?.elementAt(index);

                      return notificationCard(
                        index: index,
                        notificationsData: data,
                      );
                    },
                  )
                : NoDataScreen(
                    heightFactor: 0.9,
                    message: controller.notificationsModel?.message ?? "No Notifications Found",
                  ),
      ),
    );
  }

  Widget notificationCard({
    required int index,
    required NotificationsData? notificationsData,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, left: 16, right: 16),
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: defaultBoxShadow(),
            ),
            child: ListTile(
              leading: ImageView(
                height: 50,
                width: 50,
                borderRadiusValue: 50,
                fit: BoxFit.cover,
                networkImage: "${notificationsData?.image}",
                border: Border.all(color: Colors.grey.shade100),
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
              ),
              title: Text(
                notificationsData?.title ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notificationsData?.description ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    notificationsData?.sentAt ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xff0EAD1E),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
