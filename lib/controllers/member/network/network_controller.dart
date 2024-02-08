import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/app.dart';
import 'package:mrwebbeast/core/config/api_config.dart';
import 'package:mrwebbeast/core/services/api/exception_handler.dart';
import 'package:mrwebbeast/models/default/default_model.dart';
import 'package:mrwebbeast/models/member/network/down_line_members_model.dart';
import 'package:mrwebbeast/models/member/network/pinnacle_list_model.dart';
import 'package:mrwebbeast/models/member/network/projection_view_model.dart';

import '../../../core/services/api/api_service.dart';
import '../../../models/member/network/level_wise_member_count_model.dart';
import '../../../models/member/network/network_report_model.dart';
import '../../../models/member/network/pinnacle_view_model.dart';
import '../../../models/member/network/tree_graph_model.dart';
import '../../../utils/widgets/widgets.dart';

class NetworkControllers extends ChangeNotifier {
  /// 1) Tree View API...

  bool loadingTreeView = true;
  TreeGraphModel? networkTreeViewModel;
  List<TreeGraphData>? networkTreeViewNodes;

  Future<List<TreeGraphData>?> fetchTreeView() async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingTreeView = true;
        networkTreeViewModel = null;
        networkTreeViewNodes = null;
        notifyListeners();
      }

      onComplete() {
        loadingTreeView = false;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService().get(endPoint: ApiEndpoints.treeView);

        if (response != null) {
          Map<String, dynamic> json = response;
          TreeGraphModel responseData = TreeGraphModel.fromJson(json);
          if (responseData.status == true) {
            networkTreeViewNodes = responseData.data;

            debugPrint('networkTreeView ${networkTreeViewNodes?.length}');
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

    return networkTreeViewNodes;
  }

  /// 2) Pinnacle View Model API...

  bool loadingPinnacleView = true;
  PinnacleViewModel? pinnacleViewModel;
  List<PinnacleViewData>? pinnacleViewNodes;

  Future<List<PinnacleViewData>?> fetchPinnacleView() async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingPinnacleView = true;
        networkTreeViewModel = null;
        networkTreeViewNodes = null;
        notifyListeners();
      }

      onComplete() {
        loadingPinnacleView = false;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService().get(endPoint: ApiEndpoints.pinnacleView);

        if (response != null) {
          Map<String, dynamic> json = response;
          PinnacleViewModel responseData = PinnacleViewModel.fromJson(json);
          if (responseData.status == true) {
            pinnacleViewNodes = responseData.data;

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

    return pinnacleViewNodes;
  }

  /// 3) Projection View API...

  bool loadingProjectionView = true;
  ProjectionViewModel? projectionViewModel;
  List<ProjectionViewData>? projectionViewNodes;

  Future<List<ProjectionViewData>?> fetchProjectionView({String? memberId}) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingProjectionView = true;
        projectionViewModel = null;
        projectionViewNodes = null;
        notifyListeners();
      }

      onComplete() {
        loadingProjectionView = false;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService().get(endPoint: ApiEndpoints.projectionView, queryParameters: {
          'member_id': memberId ?? '',
        });

        if (response != null) {
          Map<String, dynamic> json = response;
          ProjectionViewModel responseData = ProjectionViewModel.fromJson(json);
          if (responseData.status == true) {
            projectionViewNodes = responseData.data;

            debugPrint('networkTreeView ${projectionViewNodes?.length}');
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

    return projectionViewNodes;
  }

  /// 4) Select AB Members API...
  Future selectABMembers({
    required BuildContext context,
    required num? memberId,
    required String? memberType,
  }) async {
    FocusScope.of(context).unfocus();

    Map<String, String> body = {
      'member_id': '$memberId',
      'member_type': '$memberType',
    };

    debugPrint('Sent Data is $body');
    try {
      var response = await loadingDialog(
        context: context,
        future: ApiService().post(
          endPoint: ApiEndpoints.selectABMembers,
          body: body,
        ),
      );

      if (response != null && context.mounted) {
        Map<String, dynamic> json = response;
        DefaultModel responseData = DefaultModel.fromJson(json);

        if (responseData.status == true) {
          fetchTreeView();
        } else {
          showError(context: context, message: responseData.message ?? 'Something Went Wrong');
        }
      }
    } catch (e, s) {
      ErrorHandler.catchError(e, s, true);
    }
  }

  /// 5) Select AB Members API...
  Future selectProjectionABMembers({
    required BuildContext context,
    required num? previousMemberId,
    required num? memberId,
    required num? parentId,
  }) async {
    FocusScope.of(context).unfocus();

    Map<String, String> body = {
      'previous_member_id': '$previousMemberId',
      'new_member_id': '$memberId',
      'parent_id': '$parentId',
    };

    debugPrint('Sent Data is $body');
    try {
      var response = await loadingDialog(
        context: context,
        future: ApiService().post(
          endPoint: ApiEndpoints.selectProjectionABMembers,
          body: body,
        ),
      );

      if (response != null && context.mounted) {
        Map<String, dynamic> json = response;
        DefaultModel responseData = DefaultModel.fromJson(json);

        if (responseData.status == true) {
          fetchProjectionView(memberId: '${memberId ?? ''}');
          context.pop();
        } else {
          showError(context: context, message: responseData.message ?? 'Something Went Wrong');
        }
      }
    } catch (e, s) {
      ErrorHandler.catchError(e, s, true);
    }
  }

  /// 6) Down Line Member Data API...

  bool loadingDownLineMember = true;
  DownLineMembersModel? downLineMembersModel;
  List<DownLineMemberData>? downLineMemberData;

  Future<List<DownLineMemberData>?> fetchDownLineMemberList({
    num? memberId,
    num? level,
    String? search,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingDownLineMember = true;
        downLineMembersModel = null;
        downLineMemberData = null;
        notifyListeners();
      }

      onComplete() {
        loadingDownLineMember = false;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.downLineMemberList,
          queryParameters: {
            'member_id': '$memberId',
            'level': '$level',
            'search_key': '$search',
          },
        );

        if (response != null) {
          Map<String, dynamic> json = response;
          DownLineMembersModel responseData = DownLineMembersModel.fromJson(json);
          if (responseData.status == true) {
            downLineMemberData = responseData.data;

            debugPrint('downLineMemberData ${downLineMemberData?.length}');
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

    return downLineMemberData;
  }

  /// 6) Pinnacle List API...

  bool loadingPinnacleList = true;
  PinnacleListModel? pinnacleListModel;
  List<PinnacleListData>? pinnacleList;

  Future<List<PinnacleListData>?> fetchPinnacleList() async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingPinnacleList = true;
        pinnacleListModel = null;
        pinnacleList = null;
        notifyListeners();
      }

      onComplete() {
        loadingPinnacleList = false;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService().get(endPoint: ApiEndpoints.fetchAllPinnacleMembers);

        if (response != null) {
          Map<String, dynamic> json = response;

          PinnacleListModel responseData = PinnacleListModel.fromJson(json);
          if (responseData.status == true) {
            pinnacleList = responseData.data;

            debugPrint('pinnacleListNodes ${pinnacleList?.length}');
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

    return pinnacleList;
  }

  /// 7) Network Reports API...
  bool loadingNetworkReports = true;
  PinnacleListModel? networkReportsModel;
  List<PinnacleListData>? networkReports;

  Future<List<PinnacleListData>?> fetchNetworkReports({
    String? search,
    String? filter,
    String? memberId,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingNetworkReports = true;
        networkReportsModel = null;
        networkReports = null;
        notifyListeners();
      }

      onComplete() {
        loadingNetworkReports = false;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.fetchAllMembers,
          queryParameters: {
            'search_key': search ?? '',
            'filter': filter ?? '',
            'member_id': memberId ?? '',
          },
        );

        if (response != null) {
          Map<String, dynamic> json = response;

          PinnacleListModel responseData = PinnacleListModel.fromJson(json);
          if (responseData.status == true) {
            networkReports = responseData.data;

            debugPrint('networkReportsNodes ${networkReports?.length}');
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

    return networkReports;
  }

  /// 8) level Wise Member Count API...
  bool loadingLevelWiseMemberCountModel = true;
  LevelWiseMemberCountModel? levelWiseMemberCountModel;

  Future<LevelWiseMemberCountModel?> levelWiseMemberCount({
    num? memberId,
    required num? level,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingLevelWiseMemberCountModel = true;
        levelWiseMemberCountModel = null;

        notifyListeners();
      }

      onComplete() {
        loadingLevelWiseMemberCountModel = false;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await loadingDialog(
          context: context,
          future: ApiService().get(
            endPoint: ApiEndpoints.levelWiseMemberCount,
            queryParameters: {
              'member_id': '${memberId ?? ''}',
              'level': '${level ?? ''}',
            },
          ),
        );

        if (response != null) {
          Map<String, dynamic> json = response;

          LevelWiseMemberCountModel responseData = LevelWiseMemberCountModel.fromJson(json);
          if (responseData.status == true) {
            levelWiseMemberCountModel = responseData;

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

    return levelWiseMemberCountModel;
  }
}
