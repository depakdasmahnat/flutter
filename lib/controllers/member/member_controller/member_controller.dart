import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrwebbeast/app.dart';
import 'package:mrwebbeast/core/config/api_config.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/services/api/exception_handler.dart';
import 'package:mrwebbeast/core/services/database/local_database.dart';
import 'package:mrwebbeast/models/member/dashboard/achievers_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/api/api_service.dart';
import '../../../models/default/default_model.dart';
import '../../../models/feeds/demos_model.dart';
import '../../../models/feeds/feeds_data.dart';
import '../../../models/member/auth/member_data.dart';
import '../../../models/member/dashboard/dashboard_states_model.dart';
import '../../../models/member/dashboard/traning_progress_model.dart';
import '../../../models/member/goals/goals_model.dart';
import '../../../models/guest_Model/fetchResouresDetailModel.dart';
import '../../../models/member/genrate_referal/genrateReferralModel.dart';
import '../../../models/member/leads/fetchLeads.dart';
import '../../../models/member/member_profile/fetchMemberProfileModel.dart';
import '../../../models/member/network/tree_graph_model.dart';
import '../../../models/member/sponsor/fetchFacilitatorModel.dart';
import '../../../models/member/sponsor/fetchSponsorModel.dart';
import '../../../utils/widgets/widgets.dart';

class MembersController extends ChangeNotifier {
  /// 1) Tree View API...
  bool showItem = false;
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
  bool leadsLoader = false;

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
        var response = await ApiService()
            .get(endPoint: '${ApiEndpoints.fetchLead}status=$status&priority=$priority&page=$page');

        if (response != null) {
          Map<String, dynamic> json = response;
          FetchLeads responseData = FetchLeads.fromJson(json);
          if (responseData.status == true) {
            fetchLeadsModel = responseData;
            notifyListeners();
          } else {
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

  ///  add lead priority
  Future<DefaultModel?> updateLeadPriority({
    required BuildContext context,
    required String? guestId,
    required String? feedback,
    required String? priority,
    required String? remark,
  }) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'guest_id': '$guestId',
      'priority': '$priority',
      'feedback': '$feedback',
      'remark': '$remark',
    };

    debugPrint('Sent Data is $body');
    var response = ApiService().post(
      endPoint: ApiEndpoints.updateLeadPriority,
      body: body,
    );
//Processing API...
    DefaultModel? responseData;
    await loadingDialog(
      context: context,
      future: response,
    ).then((response) async {
      if (response != null) {
        Map<String, dynamic> json = response;
        responseData = DefaultModel.fromJson(json);

        if (responseData?.status == true) {
          context?.pop();
        } else {
          showSnackBar(
              context: context, text: responseData?.message ?? 'Something went wong', color: Colors.red);
        }
      }
    });
    return responseData;
  }

  // bool showItem = false;

  changeStatus() {
    if (showItem == false) {
      showItem = true;
    } else {
      showItem = false;
    }
    notifyListeners();
  }

  ///  add lead status
  Future<DefaultModel?> updateLeadStatus({
    required BuildContext context,
    required String? guestId,
    required String? status,
  }) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'guest_id': '$guestId',
      'status': '$status',
      'remark': '',
    };

    debugPrint('Sent Data is $body');
    var response = ApiService().post(
      endPoint: ApiEndpoints.updateLeadStatus,
      body: body,
    );
//Processing API...
    DefaultModel? responseData;
    await loadingDialog(
      context: context,
      future: response,
    ).then((response) async {
      if (response != null) {
        Map<String, dynamic> json = response;
        responseData = DefaultModel.fromJson(json);

        if (responseData?.status == true) {
          context?.pop();
        } else {
          showSnackBar(
              context: context, text: responseData?.message ?? 'Something went wong', color: Colors.red);
        }
      }
    });
    return responseData;
  }

  /// call log
  Future<void> callUser({String? mobileNo}) async {
    final call = Uri.parse('tel:+91 $mobileNo');
    if (await canLaunchUrl(call)) {
      launchUrl(call);
    } else {
      throw 'Could not launch $call';
    }
  }

  /// scheduledDemo....
  Future<DefaultModel?> scheduledDemo({
    required BuildContext context,
    required String? guestId,
    required String? demoType,
    required String? date,
    required String? time,
    required String? remarks,
    required String? priority,
  }) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'guest_id': '$guestId',
      'demo_type': '$demoType',
      'date': '$date',
      'time': '$time',
      'priority': '$priority',
    };

    debugPrint('Sent Data is $body');
    var response = ApiService().post(
      endPoint: ApiEndpoints.scheduledDemo,
      body: body,
    );
//Processing API...
    DefaultModel? responseData;
    await loadingDialog(
      context: context,
      future: response,
    ).then((response) async {
      if (response != null) {
        Map<String, dynamic> json = response;
        responseData = DefaultModel.fromJson(json);

        if (responseData?.status == true) {
          context.pop();
        } else {
          showSnackBar(
              context: context, text: responseData?.message ?? 'Something went wong', color: Colors.red);
        }
      }
    });
    return responseData;
  }

  /// demo done

  Future<DefaultModel?> demoDoneForm({
    required BuildContext context,
    required String? demoId,
    required String? feedback,
    required String? remark,
    required String? priority,
  }) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'demo_id': '$demoId',
      'feedback': '$feedback',
      'remark': '$remark',
      'priority': '$priority',
    };

    debugPrint('Sent Data is $body');
    var response = ApiService().post(
      endPoint: ApiEndpoints.demoDone,
      body: body,
    );
//Processing API...
    DefaultModel? responseData;
    await loadingDialog(
      context: context,
      future: response,
    ).then((response) async {
      if (response != null) {
        Map<String, dynamic> json = response;
        responseData = DefaultModel.fromJson(json);

        if (responseData?.status == true) {
          context?.pop();
        } else {
          showSnackBar(
              context: context, text: responseData?.message ?? 'Something went wong', color: Colors.red);
        }
      }
    });
    return responseData;
  }

  /// 1) fetch demo details...

  bool loadingDemo = true;
  DemosModel? _demoModel;

  DemosModel? get demoModel => _demoModel;

  List<FeedsData>? _demo;

  List<FeedsData>? get demo => _demo;
  num demoIndex = 1;
  num demoTotal = 1;

  RefreshController demoController = RefreshController(initialRefresh: false);

  Future<List<FeedsData>?> fetchDemoDetail({
    required BuildContext context,
    bool isRefresh = false,
    bool loadingNext = false,
    String? searchKey,
    String? limit,
  }) async {
    String modelingData = 'FeedsData';
    debugPrint('Fetching $modelingData Data...');

    onRefresh() {
      demoIndex = 1;
      demoTotal = 1;
      loadingDemo = true;
      demoController.resetNoData();
      _demoModel = null;
      _demo = null;
      notifyListeners();
      debugPrint('Cleared $modelingData');
    }

    onComplete() {
      loadingDemo = false;
      notifyListeners();
    }

    if (isRefresh) {
      onRefresh();
    }

    Map<String, String> body = {
      'page': '$demoIndex',
      'search_key': searchKey ?? '',
      'limit': limit ?? '10',
    };

    debugPrint('Body $body');

    try {
      if (demoIndex <= demoTotal) {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.fetchDemos,
          queryParameters: body,
        );

        DemosModel? responseData;
        if (response != null) {
          Map<String, dynamic> json = response;
          responseData = DemosModel.fromJson(json);
          _demoModel = responseData;
        }

        if (responseData?.status == true) {
          debugPrint('Current Page $demoTotal');
          debugPrint(responseData?.message);
          if (responseData?.data?.haveData == true) {
            for (int i = 0; i < (responseData?.data?.length ?? 0); i++) {
              var data = responseData?.data?.elementAt(i);
              if (_demo == null) {
                debugPrint('$modelingData Added');
                if (data != null) {
                  _demo = [data];
                }
              } else {
                if (_demo?.contains(data) == true) {
                  debugPrint('$modelingData Already exit');
                } else {
                  if (data != null) {
                    _demo?.add(data);
                    debugPrint('$modelingData Updated');
                  }
                }
              }
            }
            notifyListeners();
          }

          if (loadingNext) {
            demoController.loadComplete();
          } else {
            demoController.refreshCompleted();
          }
          demoTotal = responseData?.dataRecords?.totalPage ?? 1;
          demoIndex++;
          notifyListeners();
          debugPrint('$modelingData Total Pages $demoTotal');
          debugPrint('Updated $modelingData Current Page $demoIndex');
          return _demo;
        } else {
          debugPrint(responseData?.message);
          if (loadingNext) {
            demoController.loadFailed();
          } else {
            demoController.refreshFailed();
          }
          notifyListeners();
        }
      } else {
        demoController.loadNoData();
        loadingDemo = false;
        notifyListeners();
        debugPrint('Load no More data in $modelingData');
      }
    } catch (e, s) {
      ErrorHandler.catchError(e, s, true);
    } finally {
      onComplete();
    }

    return _demo;
  }

  bool loadingGoals = true;
  GoalsModel? _goalsModel;

  GoalsModel? get goalsModel => _goalsModel;

  List<GoalsData>? _goals;

  List<GoalsData>? get goals => _goals;
  num goalsIndex = 1;
  num goalsTotal = 1;

  RefreshController goalsController = RefreshController(initialRefresh: false);

  Future<List<GoalsData>?> fetchGoals({
    required BuildContext context,
    bool isRefresh = false,
    bool loadingNext = false,
    String? searchKey,
    String? limit,
  }) async {
    String modelingData = 'FeedsData';
    debugPrint('Fetching $modelingData Data...');

    onRefresh() {
      goalsIndex = 1;
      goalsTotal = 1;
      loadingGoals = true;
      goalsController.resetNoData();
      _goalsModel = null;
      _goals = null;
      notifyListeners();
      debugPrint('Cleared $modelingData');
    }

    onComplete() {
      loadingGoals = false;
      notifyListeners();
    }

    if (isRefresh) {
      onRefresh();
    }

    Map<String, String> body = {
      'page': '$goalsIndex',
      'search_key': searchKey ?? '',
      'limit': limit ?? '10',
    };

    debugPrint('Body $body');

    try {
      if (goalsIndex <= goalsTotal) {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.fetchGoals,
          queryParameters: body,
        );

        GoalsModel? responseData;
        if (response != null) {
          Map<String, dynamic> json = response;
          responseData = GoalsModel.fromJson(json);
          _goalsModel = responseData;
        }

        if (responseData?.status == true) {
          debugPrint('Current Page $goalsTotal');
          debugPrint(responseData?.message);
          if (responseData?.data?.haveData == true) {
            for (int i = 0; i < (responseData?.data?.length ?? 0); i++) {
              GoalsData? data = responseData?.data?.elementAt(i);
              if (_goals == null) {
                debugPrint('$modelingData Added');
                if (data != null) {
                  _goals = [data];
                }
              } else {
                if (_goals?.contains(data) == true) {
                  debugPrint('$modelingData Already exit');
                } else {
                  if (data != null) {
                    _goals?.add(data);
                    debugPrint('$modelingData Updated');
                  }
                }
              }
            }
            notifyListeners();
          }

          if (loadingNext) {
            goalsController.loadComplete();
          } else {
            goalsController.refreshCompleted();
          }
          goalsTotal = responseData?.dataRecords?.totalPage ?? 1;
          goalsIndex++;
          notifyListeners();
          debugPrint('$modelingData Total Pages $goalsTotal');
          debugPrint('Updated $modelingData Current Page $goalsIndex');
          return _goals;
        } else {
          debugPrint(responseData?.message);
          if (loadingNext) {
            goalsController.loadFailed();
          } else {
            goalsController.refreshFailed();
          }
          notifyListeners();
        }
      } else {
        goalsController.loadNoData();
        loadingGoals = false;
        notifyListeners();
        debugPrint('Load no More data in $modelingData');
      }
    } catch (e, s) {
      ErrorHandler.catchError(e, s, true);
    } finally {
      onComplete();
    }

    return _goals;
  }

  /// 1) lead close...
  Future<DefaultModel?> leadClose({
    required BuildContext context,
    required String? guestId,
    required String? enagicId,
    required String? password,
  }) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'guest_id': '$guestId',
      'enagic_id': '$enagicId',
      'password': '$password',
    };

    debugPrint('Sent Data is $body');
    var response = ApiService().post(
      endPoint: ApiEndpoints.leadClose,
      body: body,
    );
//Processing API...
    DefaultModel? responseData;
    await loadingDialog(
      context: context,
      future: response,
    ).then((response) async {
      if (response != null) {
        Map<String, dynamic> json = response;
        responseData = DefaultModel.fromJson(json);

        if (responseData?.status == true) {
          context?.pop();
        } else {
          showSnackBar(
              context: context, text: responseData?.message ?? 'Something went wong', color: Colors.red);
        }
      }
    });
    return responseData;
  }

  /// 1) fetch sponsor..
  FetchSponsorModel? fetchSponsorModel;
  bool sponsorLoader = false;

  Future<FetchSponsorModel?> fetchSponsor({
    required BuildContext context,
    // required String stateId,
    // required String categoryId,
  }) async {
    refresh() {
      sponsorLoader = false;
      fetchSponsorModel = null;
      notifyListeners();
    }

    // //
    apiResponseCompleted() {
      sponsorLoader = true;
      notifyListeners();
    }

    //
    refresh();
    try {
      await ApiService()
          .get(
        endPoint: ApiEndpoints.fetchSponsor,
      )
          .then(
        (response) {
          if (response != null) {
            Map<String, dynamic> json = response;
            FetchSponsorModel responseData = FetchSponsorModel.fromJson(json);
            if (responseData.status == true) {
              fetchSponsorModel = responseData;
              notifyListeners();
            }
          }
        },
      );
      apiResponseCompleted();
    } catch (e, s) {
      apiResponseCompleted();
      debugPrint('Error is $e & $s');
    } finally {
      apiResponseCompleted();
    }
    {}

    return fetchSponsorModel;
  }

  /// 1) add list..

  Map<String, dynamic>? uploadVideoResponse;
  DefaultModel? defaultModel;
  bool addLeadLoader = false;

  Future addList({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String mobile,
    required String email,
    required String gender,
    required String leadRefType,
    required String occupation,
    required String dob,
    required String noOfFamilyMembers,
    required String illnessInFamily,
    required String stateId,
    required String cityId,
    required String address,
    required String pincode,
    required String disability,
    required String monthlyIncome,
    required String sponsorId,
    required XFile? file,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;
    if (context != null) {
      FocusScope.of(context).unfocus();
      Map<String, String> body = {
        'first_name': firstName,
        'last_name': lastName,
        'mobile': mobile,
        'email': email,
        'gender': gender,
        'lead_ref_type': leadRefType,
        'occupation': occupation,
        'dob': dob,
        'no_of_family_members': noOfFamilyMembers,
        'illness_in_family': illnessInFamily,
        'state_id': stateId,
        'city_id': cityId,
        'address': address,
        'pincode': pincode,
        'disability': disability,
        'monthly_income': monthlyIncome,
        'sponsor_id': sponsorId,
      };
      debugPrint('Sent Data is $body');
      //Processing API...
      var response = ApiService().multiPart(
        endPoint: ApiEndpoints.addLead,
        body: body,
        multipartFile: [if (file != null) MultiPartData(field: 'profile_photo', filePath: file.path)],
      );
      await loadingDialog(
        context: context,
        future: response,
      ).then(
        (response) {
          if (response != null) {
            Map<String, dynamic> json = response;
            uploadVideoResponse = json;
            notifyListeners();
            DefaultModel responseData = DefaultModel.fromJson(json);
            if (responseData?.status == true) {
              showSnackBar(
                  context: context,
                  text: responseData.message ?? 'List add successfully',
                  color: Colors.green);
              showItem = false;
              context?.pop();
              notifyListeners();
            } else {
              showSnackBar(
                  context: context, text: responseData.message ?? 'Something went wong', color: Colors.red);
            }
          }
        },
      );
      // return ApiService().multiPart(
      //   endPoint: ApiEndpoints.addLead,
      //   body: body,
      //   multipartFile: [if (file != null) MultiPartData(field: 'profile_photo', filePath: file.path)],
      // ).then((response) async {
      //
      // });
    }
  }

  GenrateReferralModel? generateReferralModel;
  bool generateRefLoader = false;

  Future<GenrateReferralModel?> fetchReferral({
    required BuildContext context,
    // required String stateId,
    // required String categoryId,
  }) async {
    refresh() {
      generateRefLoader = false;
      generateReferralModel = null;
      notifyListeners();
    }

    // //
    apiResponseCompleted() {
      generateRefLoader = true;
      notifyListeners();
    }

    //
    refresh();
    try {
      await ApiService()
          .get(
        endPoint: ApiEndpoints.ref,
      )
          .then(
        (response) {
          if (response != null) {
            Map<String, dynamic> json = response;
            GenrateReferralModel responseData = GenrateReferralModel.fromJson(json);
            if (responseData.status == true) {
              generateReferralModel = responseData;
              notifyListeners();
            }
          }
        },
      );
      apiResponseCompleted();
    } catch (e, s) {
      apiResponseCompleted();
      debugPrint('Error is $e & $s');
    }

    return generateReferralModel;
  }

  ///  fetch memberProfile...
  FetchMemberProfileModel? fetchMemberProfileModel;
  bool memberProfileLoader = false;

  Future<FetchMemberProfileModel?> fetchMemberProfile({
    required BuildContext context,
    required String memberID,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        memberProfileLoader = false;
        fetchMemberProfileModel = null;
        notifyListeners();
      }

      onComplete() {
        memberProfileLoader = true;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService().get(endPoint: ApiEndpoints.memberProfile + memberID);

        if (response != null) {
          Map<String, dynamic> json = response;
          FetchMemberProfileModel responseData = FetchMemberProfileModel.fromJson(json);
          if (responseData.status == true) {
            fetchMemberProfileModel = responseData;
            notifyListeners();
          } else {
            fetchMemberProfileModel = responseData;
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
    return fetchMemberProfileModel;
  }

  /// 1) fetch facilitator..
  FetchFacilitatorModel? fetchFacilitatorModel;

  Future<FetchFacilitatorModel?> fetchFacilitator({
    required BuildContext context,
  }) async {
    // refresh() {
    //   resourcesDetailLoader = false;
    //
    //   notifyListeners();
    // }
    // //
    // apiResponseCompleted() {
    //   resourcesDetailLoader = true;
    //   notifyListeners();
    // }
    //
    // refresh();
    try {
      await ApiService()
          .get(
        endPoint: ApiEndpoints.fetchFacilitator,
      )
          .then(
        (response) {
          if (response != null) {
            Map<String, dynamic> json = response;
            FetchFacilitatorModel responseData = FetchFacilitatorModel.fromJson(json);
            if (responseData.status == true) {
              fetchFacilitatorModel = responseData;
              notifyListeners();
            }
          }
        },
      );
    } catch (e, s) {
      // apiResponseCompleted();
      debugPrint('Error is $e & $s');
    }

    return fetchFacilitatorModel;
  }

  /// 1) add facilitator..

  // Map<String, dynamic>? uploadVideoResponse;
  DefaultModel? defaultFacilatatorModel;

  // bool addLeadLoader=false;
  Future addFacilitatorList({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String mobile,
    required String email,
    required String enagicId,
    required String password,
    required String gender,
    required String leadRefType,
    required String occupation,
    required String dob,
    required String noOfFamilyMembers,
    required String illnessInFamily,
    required String stateId,
    required String cityId,
    required String address,
    required String pincode,
    required String disability,
    required String monthlyIncome,
    required String sponsorId,
    required String salesFacilitatorId,
    required XFile? file,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;
    if (context != null) {
      FocusScope.of(context).unfocus();
      Map<String, String> body = {
        'first_name': firstName,
        'last_name': lastName,
        'mobile': mobile,
        'email': email,
        'enagic_id': enagicId,
        'password': password,
        'gender': gender,
        'lead_ref_type': leadRefType,
        'occupation': occupation,
        'dob': dob,
        'no_of_family_members': noOfFamilyMembers,
        'illness_in_family': illnessInFamily,
        'state_id': stateId,
        'city_id': cityId,
        'address': address,
        'pincode': pincode,
        'disability': disability,
        'monthly_income': monthlyIncome,
        'sponsor_id': sponsorId,
        'sales_facilitator_id': salesFacilitatorId,
      };
      debugPrint('Sent Data is $body');
      //Processing API...
      var response = ApiService().multiPart(
        endPoint: ApiEndpoints.addNewMemberLead,
        body: body,
        multipartFile: file != null ? [MultiPartData(field: 'profile_photo', filePath: file?.path)] : [],
      );
      await loadingDialog(
        context: context,
        future: response,
      ).then(
        (response) {
          if (response != null) {
            Map<String, dynamic> json = response;
            uploadVideoResponse = json;
            notifyListeners();
            DefaultModel responseData = DefaultModel.fromJson(json);
            if (responseData?.status == true) {
              showSnackBar(
                  context: context,
                  text: responseData.message ?? 'List add successfully',
                  color: Colors.green);
              showItem = false;
              context?.pop();
              notifyListeners();
            } else {
              showSnackBar(
                  context: context, text: responseData.message ?? 'Something went wong', color: Colors.red);
            }
          }
        },
      );
      // return ApiService().multiPart(
      //   endPoint: ApiEndpoints.addLead,
      //   body: body,
      //   multipartFile: [if (file != null) MultiPartData(field: 'profile_photo', filePath: file.path)],
      // ).then((response) async {
      //
      // });
    }
  }

  // Map<String, dynamic>? uploadVideoResponse;
  DefaultModel? defaultTargetModel;

  // bool addLeadLoader=false;
  Future addTarget({
    required BuildContext context,
    required String salesTarget,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;
    if (context != null) {
      FocusScope.of(context).unfocus();
      Map<String, String> body = {
        'sales_target': salesTarget,
      };
      debugPrint('Sent Data is $body');

      var response = ApiService().post(
        endPoint: ApiEndpoints.addTarget,
        body: body,
      );
      await loadingDialog(
        context: context,
        future: response,
      ).then(
        (response) {
          if (response != null) {
            Map<String, dynamic> json = response;
            DefaultModel responseData = DefaultModel.fromJson(json);
            if (responseData?.status == true) {
              showSnackBar(
                  context: context,
                  text: responseData.message ?? 'List add successfully',
                  color: Colors.green);

              context?.pop();
              notifyListeners();
            } else {
              showSnackBar(
                  context: context, text: responseData.message ?? 'Something went wong', color: Colors.red);
            }
          }
        },
      );
      // return ApiService().multiPart(
      //   endPoint: ApiEndpoints.addLead,
      //   body: body,
      //   multipartFile: [if (file != null) MultiPartData(field: 'profile_photo', filePath: file.path)],
      // ).then((response) async {
      //
      // });
    }
  }

  /// 1) edit member profile..

  // / Map<String, dynamic>? uploadVideoResponse;
  DefaultModel? defaultEditMemberModel;

  // bool addLeadLoader=false;
  Future editMemberProfile({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String mobile,
    required String email,
    // required String enagicId,
    // required String password,
    required String gender,
    required String leadRefType,
    required String occupation,
    required String dob,
    required String noOfFamilyMembers,
    required String illnessInFamily,
    required String stateId,
    required String cityId,
    required String address,
    required String pincode,
    required String disability,
    required String monthlyIncome,
    required String sponsorId,
    required String salesFacilitatorId,
    required XFile? file,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;
    if (context != null) {
      FocusScope.of(context).unfocus();
      Map<String, String> body = {
        'first_name': firstName,
        'last_name': lastName,
        'mobile': mobile,
        'email': email,
        // 'enagic_id': enagicId,
        // 'password': password,
        'gender': gender,
        'lead_ref_type': leadRefType,
        'occupation': occupation,
        'dob': dob,
        'no_of_family_members': noOfFamilyMembers,
        'illness_in_family': illnessInFamily,
        'state_id': stateId,
        'city_id': cityId,
        'address': address,
        'pincode': pincode,
        'disability': disability,
        'monthly_income': monthlyIncome,
        'sponsor_id': sponsorId,
        'sales_facilitator_id': salesFacilitatorId,
      };
      debugPrint('Sent Data is $body');
      debugPrint('this is member edit profile');
      //Processing API...
      var response = ApiService().multiPart(
        endPoint: ApiEndpoints.editMember,
        body: body,
        multipartFile: file != null ? [MultiPartData(field: 'profile_photo', filePath: file?.path)] : [],
      );
      await loadingDialog(
        context: context,
        future: response,
      ).then(
        (response) {
          if (response != null) {
            Map<String, dynamic> json = response;

            notifyListeners();
            DefaultModel responseData = DefaultModel.fromJson(json);
            if (responseData?.status == true) {
              showSnackBar(
                  context: context,
                  text: responseData.message ?? 'List add successfully',
                  color: Colors.green);
              context?.pop();
              notifyListeners();
            } else {
              showSnackBar(
                  context: context, text: responseData.message ?? 'Something went wong', color: Colors.red);
            }
          }
        },
      );
      // return ApiService().multiPart(
      //   endPoint: ApiEndpoints.addLead,
      //   body: body,
      //   multipartFile: [if (file != null) MultiPartData(field: 'profile_photo', filePath: file.path)],
      // ).then((response) async {
      //
      // });
    }
  }

  // /// 1) fetch facilitator..
  // FetchFacilitatorModel? fetchFacilitatorModel;
  //
  // Future<FetchFacilitatorModel?> fetchFacilitator({
  //   required BuildContext context,
  //
  // }) async {
  //   // refresh() {
  //   //   resourcesDetailLoader = false;
  //   //
  //   //   notifyListeners();
  //   // }
  //   // //
  //   // apiResponseCompleted() {
  //   //   resourcesDetailLoader = true;
  //   //   notifyListeners();
  //   // }
  //   //
  //   // refresh();
  //   try {
  //     await  ApiService().get(
  //       endPoint: ApiEndpoints.fetchFacilitator ,
  //     ).then((response) {
  //       if (response != null) {
  //         Map<String, dynamic> json = response;
  //         FetchFacilitatorModel responseData = FetchFacilitatorModel.fromJson(json);
  //         if (responseData.status == true) {
  //           fetchFacilitatorModel = responseData;
  //           notifyListeners();
  //         }
  //       }
  //     },);
  //
  //   } catch (e, s) {
  //     // apiResponseCompleted();
  //     debugPrint('Error is $e & $s');
  //   }
  //
  //   return fetchFacilitatorModel;
  // }

  /// 1) add list..

  // Map<String, dynamic>? uploadVideoResponse;
  // DefaultModel? createEventModel;
  // bool addLeadLoader=false;
  Future createEvent({
    required BuildContext context,
    required String name,
    required String eventType,
    required String meetingLink,
    required String city,
    required String description,
    required String startDate,
    required String startTime,
    required String endDate,
    required String endTime,
    required String memberIds,
    required XFile? file,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;
    if (context != null) {
      FocusScope.of(context).unfocus();
      Map<String, String> body = {
        'name': name,
        'type': eventType,
        'meeting_link': meetingLink,
        'location': city,
        'description': description,
        'start_date': startDate,
        'start_time': startTime,
        'end_date': endDate,
        'end_time': endTime,
        'member_ids': memberIds,
      };
      debugPrint('Sent Data is $body');
      //Processing API...
      var response = ApiService().multiPart(
        endPoint: ApiEndpoints.createEvent,
        body: body,
        multipartFile: [if (file != null) MultiPartData(field: 'image', filePath: file.path)],
      );
      await loadingDialog(
        context: context,
        future: response,
      ).then(
        (response) {
          if (response != null) {
            Map<String, dynamic> json = response;
            // uploadVideoResponse = json;
            notifyListeners();
            DefaultModel responseData = DefaultModel.fromJson(json);
            if (responseData?.status == true) {
              showSnackBar(
                  context: context, text: responseData.message ?? 'Event Crated', color: Colors.green);
              // showItem=false;
              context?.pop();
              notifyListeners();
            } else {
              showSnackBar(
                  context: context, text: responseData.message ?? 'Something went wong', color: Colors.red);
            }
          }
        },
      );
      // return ApiService().multiPart(
      //   endPoint: ApiEndpoints.addLead,
      //   body: body,
      //   multipartFile: [if (file != null) MultiPartData(field: 'profile_photo', filePath: file.path)],
      // ).then((response) async {
      //
      // });
    }
  }

  /// 1) add goal..

  // Map<String, dynamic>? uploadVideoResponse;
  // DefaultModel? createEventModel;
  // bool addLeadLoader=false;
  Future addGoal({
    required BuildContext context,
    required String name,
    required String goalType,
    required String startDate,
    required String endDate,
    required String description,
    required XFile? file,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;
    if (context != null) {
      FocusScope.of(context).unfocus();
      Map<String, String> body = {
        'name': name,
        'type': goalType,
        'start_date': startDate,
        'end_date': endDate,
        'description': description,
      };
      debugPrint('Sent Data is $body');
      var response = ApiService().multiPart(
        endPoint: ApiEndpoints.addGoal,
        body: body,
        multipartFile: [if (file != null) MultiPartData(field: 'image', filePath: file.path)],
      );
      await loadingDialog(
        context: context,
        future: response,
      ).then(
        (response) {
          if (response != null) {
            Map<String, dynamic> json = response;
            notifyListeners();
            DefaultModel responseData = DefaultModel.fromJson(json);
            if (responseData?.status == true) {
              showSnackBar(
                  context: context, text: responseData.message ?? 'Event Crated', color: Colors.green);
              // showItem=false;
              context?.pop();
              notifyListeners();
            } else {
              showSnackBar(
                  context: context, text: responseData.message ?? 'Something went wong', color: Colors.red);
            }
          }
        },
      );
      // return ApiService().multiPart(
      //   endPoint: ApiEndpoints.addLead,
      //   body: body,
      //   multipartFile: [if (file != null) MultiPartData(field: 'profile_photo', filePath: file.path)],
      // ).then((response) async {
      //
      // });
    }
  }

  /// 1) Dashboard States API...

  bool loadingDashboardStates = true;
  DashboardStatesModel? dashboardStatesModel;
  DashboardStatesData? dashboardStatesData;

  Future<DashboardStatesData?> fetchDashboardStates({
    num? memberId,
    String? filter,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingDashboardStates = true;
        dashboardStatesModel = null;
        dashboardStatesData = null;
        notifyListeners();
      }

      onComplete() {
        loadingDashboardStates = false;
        notifyListeners();
      }

      onRefresh();
      MemberData? member = LocalDatabase().member;
      try {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.fetchDashboardStats,
          queryParameters: {
            'member_id': '${memberId ?? member?.id}',
            'filter': '$filter',
          },
        );

        if (response != null) {
          Map<String, dynamic> json = response;
          DashboardStatesModel responseData = DashboardStatesModel.fromJson(json);
          if (responseData.status == true) {
            dashboardStatesData = responseData.data;
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

    return dashboardStatesData;
  }

  /// 7) Achievers API...

  bool loadingAchievers = true;
  AchieversModel? achieversModel;
  List<AchieversData>? achievers;

  Future<List<AchieversData>?> fetchAchievers({
    String? search,
    String? filter,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingAchievers = true;
        achieversModel = null;
        achievers = null;
        notifyListeners();
      }

      onComplete() {
        loadingAchievers = false;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService().get(endPoint: ApiEndpoints.getAchievers, queryParameters: {
          'search_key': search ?? '',
          'filter': filter ?? '',
        });

        if (response != null) {
          Map<String, dynamic> json = response;

          AchieversModel responseData = AchieversModel.fromJson(json);
          if (responseData.status == true) {
            achievers = responseData.data;

            debugPrint('achieversNodes ${achievers?.length}');
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

    return achievers;
  }

  bool loadingTrainingProgress = true;
  TrainingProgressModel? trainingProgress;

  Future<TrainingProgressModel?> fetchTrainingProgress() async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingTrainingProgress = true;
        // trainingProgress = null;

        notifyListeners();
      }

      onComplete() {
        loadingTrainingProgress = false;
        notifyListeners();
      }

      onRefresh();

      try {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.fetchTrainingProcess, // Update the endpoint
        );

        if (response != null) {
          Map<String, dynamic> json = response;
          TrainingProgressModel responseData = TrainingProgressModel.fromJson(json);
          if (responseData.status == true) {
            trainingProgress = responseData;
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

    return trainingProgress;
  }
}
