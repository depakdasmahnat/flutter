import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/app.dart';
import 'package:mrwebbeast/core/config/api_config.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/services/api/exception_handler.dart';
import 'package:mrwebbeast/models/default/default_model.dart';
import 'package:mrwebbeast/models/member/network/down_line_members_model.dart';
import 'package:mrwebbeast/models/member/network/projection_view_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/services/api/api_service.dart';
import '../../../models/member/events/events_model.dart';
import '../../../models/member/network/pinnacle_view_model.dart';
import '../../../models/member/network/tree_graph_model.dart';
import '../../../models/member/todo/to_do_model.dart';
import '../../../utils/widgets/widgets.dart';

class EventsControllers extends ChangeNotifier {
  /// 1) Events API...
  bool loadingEvents = true;
  EventsModel? _eventsModel;

  EventsModel? get eventsModel => _eventsModel;

  List<EventsData>? _events;

  List<EventsData>? get events => _events;
  num eventsIndex = 1;
  num eventsTotal = 1;

  RefreshController eventsController = RefreshController(initialRefresh: false);

  Future<List<EventsData>?> fetchEvents({
    required BuildContext context,
    bool isRefresh = false,
    bool loadingNext = false,
    String? searchKey,
    String? limit,
    num? eventId,
    String? filter,
  }) async {
    String modelingData = 'EventsData';
    debugPrint('Fetching $modelingData Data...');

    onRefresh() {
      eventsIndex = 1;
      eventsTotal = 1;
      loadingEvents = true;
      eventsController.resetNoData();
      _eventsModel = null;
      _events = null;
      notifyListeners();
      debugPrint('Cleared $modelingData');
    }

    onComplete() {
      loadingEvents = false;
      notifyListeners();
    }

    if (isRefresh) {
      onRefresh();
    }

    Map<String, String> body = {
      'id': '${eventId ?? ' '}',
      'page': '$eventsIndex',
      'search_key': searchKey ?? '',
      'filter': filter ?? '',
      'limit': limit ?? '10',
    };

    debugPrint('Body $body');

    try {
      if (eventsIndex <= eventsTotal) {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.fetchEvents,
          queryParameters: body,
        );

        EventsModel? responseData;
        if (response != null) {
          Map<String, dynamic> json = response;
          responseData = EventsModel.fromJson(json);
          _eventsModel = responseData;
        }

        if (responseData?.status == true) {
          debugPrint('Current Page $eventsTotal');
          debugPrint(responseData?.message);

          if (responseData?.data?.haveData == true) {
            for (int i = 0; i < (responseData?.data?.length ?? 0); i++) {
              var data = responseData?.data?.elementAt(i);
              if (_events == null) {
                debugPrint('$modelingData Added');
                if (data != null) {
                  _events = [data];
                }
              } else {
                if (_events?.contains(data) == true) {
                  debugPrint('$modelingData Already exit');
                } else {
                  if (data != null) {
                    _events?.add(data);
                    debugPrint('$modelingData Updated');
                  }
                }
              }
            }
            notifyListeners();
          }

          if (loadingNext) {
            eventsController.loadComplete();
          } else {
            eventsController.refreshCompleted();
          }
          eventsTotal = responseData?.dataRecords?.totalPage ?? 1;
          eventsIndex++;
          notifyListeners();
          debugPrint('$modelingData Total Pages $eventsTotal');
          debugPrint('Updated $modelingData Current Page $eventsIndex');
          return _events;
        } else {
          debugPrint(responseData?.message);
          if (loadingNext) {
            eventsController.loadFailed();
          } else {
            eventsController.refreshFailed();
          }
          notifyListeners();
        }
      } else {
        eventsController.loadNoData();
        loadingEvents = false;
        notifyListeners();
        debugPrint('Load no More data in $modelingData');
      }
    } catch (e, s) {
      ErrorHandler.catchError(e, s, true);
    } finally {
      onComplete();
    }

    return _events;
  }

  /// 2) ToDo API...
  bool loadingToDos = true;
  ToDoModel? toDoModel;
  ToDoData? toDos;

  Future<ToDoData?> fetchToDos({
    String? search,
    String? filter,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingToDos = true;
        toDoModel = null;
        toDos = null;
        notifyListeners();
      }

      onComplete() {
        loadingToDos = false;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService().get(endPoint: ApiEndpoints.fetchToDo, queryParameters: {
          'search_key': search ?? '',
          'filter': filter ?? '',
        });

        if (response != null) {
          Map<String, dynamic> json = response;

          ToDoModel responseData = ToDoModel.fromJson(json);
          if (responseData.status == true) {
            toDos = responseData.data;

            notifyListeners();
          }
        }
      } catch (e, s) {
        onComplete();
        ErrorHandler.catchError(e, s, true);
      } finally {
        onComplete();
      }
    }

    return toDos;
  }
}
