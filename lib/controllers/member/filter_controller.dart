import 'package:flutter/cupertino.dart';
import 'package:mrwebbeast/core/services/api/exception_handler.dart';

import '../../app.dart';
import '../../core/config/api_config.dart';
import '../../core/services/api/api_service.dart';
import '../../models/member/filter/filter_model.dart';

class FilterController extends ChangeNotifier {
  ///1)  Fetch Occupations

  bool loadingOccupations = true;
  FilterModel? occupationsModel;
  List<FilterData>? occupations;

  Future<List<FilterData>?> fetchOccupations() async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingOccupations = true;
        occupationsModel = null;
        occupations = null; // Renamed from networkTreeView
        notifyListeners();
      }

      onComplete() {
        loadingOccupations = false;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService().get(endPoint: ApiEndpoints.fetchOccupation);

        if (response != null) {
          Map<String, dynamic> json = response;
          FilterModel responseData = FilterModel.fromJson(json);
          if (responseData.status == true) {
            occupations = responseData.data; // Renamed from networkTreeView
            debugPrint('filterModels ${occupations?.length}'); // Renamed from networkTreeView
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

    return occupations; // Renamed from networkTreeView
  }

  ///2)  fetchMachineType

  bool loadingMachineTypes = true;
  FilterModel? machineTypeModel;
  List<FilterData>? machineTypes;

  Future<List<FilterData>?> fetchMachineType() async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingMachineTypes = true;
        occupationsModel = null;
        machineTypes = null; // Renamed from occupations
        notifyListeners();
      }

      onComplete() {
        loadingMachineTypes = false;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService().get(endPoint: ApiEndpoints.fetchMachineType);

        if (response != null) {
          Map<String, dynamic> json = response;
          FilterModel responseData = FilterModel.fromJson(json);
          if (responseData.status == true) {
            machineTypes = responseData.data; // Renamed from occupations
            debugPrint('machineTypes ${machineTypes?.length}'); // Renamed from occupations
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

    return machineTypes; // Renamed from occupations
  }

  ///2)  fetchMachineType

  bool loadingObjections = true;
  FilterModel? objectionModel;
  List<FilterData>? objections;

  Future<List<FilterData>?> fetchObjections() async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingObjections = true;
        objectionModel = null; // Renamed from occupationsModel
        objections = null; // Renamed from machineTypes
        notifyListeners();
      }

      onComplete() {
        loadingObjections = false;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService().get(endPoint: ApiEndpoints.fetchObjectionList);

        if (response != null) {
          Map<String, dynamic> json = response;
          FilterModel responseData = FilterModel.fromJson(json);
          if (responseData.status == true) {
            objections = responseData.data; // Renamed from machineTypes
            debugPrint('Objections ${objections?.length}'); // Renamed from machineTypes
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

    return objections; // Renamed from machineTypes
  }
}
