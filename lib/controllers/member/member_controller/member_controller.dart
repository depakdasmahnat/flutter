import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/app.dart';

import 'package:mrwebbeast/core/config/api_config.dart';
import 'package:mrwebbeast/core/services/api/exception_handler.dart';

import '../../../core/services/api/api_service.dart';

import '../../../models/member/leads/fetchLeads.dart';
import '../../../models/member/network/tree_graph_model.dart';

class MembersController extends ChangeNotifier {
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



  /// lead Apis



  ///  fetch leads
  FetchLeads? fetchLeadsModel;
  bool leadsLoader =false;
  Future<FetchLeads?> fetchLeads({
    String? status,
    String? priority,
    String? page,
}) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        leadsLoader = false;
        fetchLeadsModel = null;

        notifyListeners();
      }

      onComplete() {
        leadsLoader = true;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService().get(
            endPoint: '${ApiEndpoints.fetchLead}status=$status&priority=$priority&page=$page'
        );

        if (response != null) {
          Map<String, dynamic> json = response;
          FetchLeads responseData = FetchLeads.fromJson(json);
          if (responseData.status == true) {
            fetchLeadsModel = responseData;
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

    return fetchLeadsModel;
  }

}
