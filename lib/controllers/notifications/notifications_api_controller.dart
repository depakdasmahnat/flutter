
import 'package:flutter/cupertino.dart';
import 'package:gaas/core/services/api/api_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/services/database/local_database.dart';
import '../../models/notifications/notifications_model.dart';

class NotificationsAPIController extends ChangeNotifier {
  bool loadingNotifications = true;
  NotificationsModel? notificationsModel;
  List<NotificationsData>? notificationsData;
  num notificationsCurrentPage = 0;
  num notificationsTotalPages = 1;

  RefreshController notificationController = RefreshController(initialRefresh: false);

  Future fetchAllNotifications({
    bool isRefresh = false,
    bool loadingNext = false,
    String? partnerType,
    required BuildContext context,
  }) async {
    debugPrint("fetch All Notifications");

    if (isRefresh) {
      notificationsCurrentPage = 0;
      notificationsTotalPages = 1;
      loadingNotifications = true;
      notificationController.resetNoData();

      if (notificationsModel != null && notificationsData != null) {
        notificationsModel = null;
        notificationsData = null;
        notifyListeners();
        debugPrint("cleared");
      }
      notifyListeners();
    }

    if (notificationsCurrentPage <= notificationsTotalPages) {
      try {
        Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
        Map<String, String> body = {
          if (partnerType != null)   "type": partnerType,
        };
        var response = await ApiService().get(
          context: context,
          endPoint: "/fetch_notifications${queryParameter(body: body)}",
          headers: headers,
        );

        Map<String, dynamic> json = response;
        notificationsModel = NotificationsModel.fromJson(json);
        if (notificationsModel?.status != null) {
          debugPrint("Current Page $notificationsCurrentPage");

          for (int i = 0; i < notificationsModel!.data!.length; i++) {
            if (notificationsData == null) {
              notificationsData = [notificationsModel!.data!.elementAt(i)];
            } else {
              if (notificationsData!.contains(notificationsModel!.data!.elementAt(i))) {
                debugPrint("notificationsData Already exit");
              } else {
                notificationsData!.add(notificationsModel!.data!.elementAt(i));
                debugPrint("notificationsData  Updated ");
              }
            }
          }
          if (loadingNext) {
            notificationController.loadComplete();
          } else {
            notificationController.refreshCompleted();
          }
          notificationsTotalPages = notificationsModel?.counts ?? 1;
          notificationsCurrentPage++;
          notifyListeners();
          debugPrint("Total Pages $notificationsTotalPages");
          debugPrint("Updated Current Page $notificationsCurrentPage");
        } else {
          notificationsModel = NotificationsModel.fromJson(json);
          if (loadingNext) {
            notificationController.loadFailed();
          } else {
            notificationController.refreshFailed();
          }
          notifyListeners();
        }
      } catch (e, s) {
        debugPrint("$e\n\n$s");
      } finally {
        loadingNotifications = false;
        notifyListeners();
      }
    } else {
      notificationController.loadNoData();
      loadingNotifications = false;
      notifyListeners();
      debugPrint("Load no More data ");
      return notificationsModel;
    }
  }
}
