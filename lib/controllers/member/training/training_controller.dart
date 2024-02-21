import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/app.dart';
import 'package:mrwebbeast/core/config/api_config.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/core/services/api/exception_handler.dart';
import 'package:mrwebbeast/models/default/default_model.dart';
import 'package:mrwebbeast/models/member/training/chapter_details_model.dart';
import 'package:mrwebbeast/models/member/training/chapters_model.dart';
import 'package:mrwebbeast/models/member/training/quiz_model.dart';
import 'package:mrwebbeast/screens/member/training/exam_report.dart';

import '../../../core/services/api/api_service.dart';
import '../../../models/member/training/quiz_report_model.dart';
import '../../../models/member/training/training_categories_model.dart';
import '../../../utils/widgets/widgets.dart';

class TrainingControllers extends ChangeNotifier {
  /// 1) Fetch Trainings API...

  bool loadingTrainingCategories = true;
  TrainingCategoriesModel? trainingCategoriesModel;
  List<TrainingCategoryData>? trainingCategories;

  Future<List<TrainingCategoryData>?> fetchTrainings({
    required bool? basic,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingTrainingCategories = true;
        trainingCategoriesModel = null;
        trainingCategories = null;
        notifyListeners();
      }

      onComplete() {
        loadingTrainingCategories = false;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.fetchTrainings,
          queryParameters: {
            'category_type': basic == true ? 'Basic' : 'Advance',
          },
        );

        if (response != null) {
          Map<String, dynamic> json = response;
          TrainingCategoriesModel responseData = TrainingCategoriesModel.fromJson(json);
          if (responseData.status == true) {
            trainingCategories = responseData.data;

            debugPrint('fetchTrainings ${trainingCategories?.length}');
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

    return trainingCategories;
  }

  /// 2) Chapter API...

  bool loadingChapters = true;
  ChaptersModel? chaptersModel;
  List<ChapterData>? chapters;

  Future<List<ChapterData>?> fetchChapters({num? trainingId}) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingChapters = true;
        chaptersModel = null;
        chapters = null;
        notifyListeners();
      }

      onComplete() {
        loadingChapters = false;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.fetchChapters,
          queryParameters: {
            'training_id': '${trainingId ?? ''}',
          },
        );

        if (response != null) {
          Map<String, dynamic> json = response;
          ChaptersModel responseData = ChaptersModel.fromJson(json);
          if (responseData.status == true) {
            chapters = responseData.data;

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

    return chapters;
  }

  /// 3) Chapter Details API...

  bool loadingChapterDetails = true;
  ChapterDetailsModel? projectionViewModel;
  ChapterDetailsData? chapterDetails;

  Future<ChapterDetailsData?> fetchChapterDetails({num? chapterId}) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingChapterDetails = true;
        projectionViewModel = null;
        chapterDetails = null;
        notifyListeners();
      }

      onComplete() {
        loadingChapterDetails = false;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.fetchChapterDetails,
          queryParameters: {
            'chapter_id': '${chapterId ?? ''}',
          },
        );

        if (response != null) {
          Map<String, dynamic> json = response;
          ChapterDetailsModel responseData = ChapterDetailsModel.fromJson(json);
          if (responseData.status == true) {
            chapterDetails = responseData.data;

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

    return chapterDetails;
  }

  /// 4) Quiz API...

  bool loadingQuizzes = true;
  QuizModel? quizModel;
  List<QuizData>? quizzes;

  Future<List<QuizData>?> fetchQuizzes({num? chapterId}) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingQuizzes = true;
        projectionViewModel = null;
        quizzes = null;
        notifyListeners();
      }

      onComplete() {
        loadingQuizzes = false;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.fetchTests,
          queryParameters: {
            'chapter_id': '${chapterId ?? ''}',
          },
        );

        if (response != null) {
          Map<String, dynamic> json = response;
          QuizModel responseData = QuizModel.fromJson(json);
          if (responseData.status == true) {
            quizzes = responseData.data;

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

    return quizzes;
  }

  /// 4) submit Users Answer API...
  Future selectUsersAnswer({
    required BuildContext context,
    required int index,
    required String? answer,
  }) async {
    FocusScope.of(context).unfocus();
    quizzes?[index].selectedAnswer = answer;
    notifyListeners();
  }

  Future submitUsersAnswer({
    required BuildContext context,
    required num? chapterId,
  }) async {
    FocusScope.of(context).unfocus();
    List<Map<String, String>> testAns = [];
    if (quizzes?.any((element) => element.selectedAnswer != null) == false) {
      showSnackBar(context: context, text: 'Select at least 1 Answer');
      return true;
    }

    quizzes?.forEach((element) {
      testAns.add(
        {
          'id': '${element.id}',
          'selected_answer': '${element.selectedAnswer}',
        },
      );
    });
    Map<String, String> body = {
      'chapter_id': '$chapterId',
      'test_ans': jsonEncode(testAns),
    };

    debugPrint('Sent Data is $body');
    try {
      var response = await loadingDialog(
        context: context,
        future: ApiService().post(
          endPoint: ApiEndpoints.submitUsersAnswer,
          body: body,
        ),
      );

      if (response != null && context.mounted) {
        Map<String, dynamic> json = response;
        QuizReportModel responseData = QuizReportModel.fromJson(json);
        if (responseData.status == true) {
          context.firstRoute();
          context.pushNamed(Routs.examReport, extra: ExamReport(report: responseData));
        } else {
          showError(context: context, message: responseData.message ?? 'Something Went Wrong');
        }
      }
    } catch (e, s) {
      ErrorHandler.catchError(e, s, true);
    }
  }

// /// 5) Select AB Members API...
// Future selectProjectionABMembers({
//   required BuildContext context,
//   required num? previousMemberId,
//   required num? memberId,
//   required num? parentId,
// }) async {
//   FocusScope.of(context).unfocus();
//
//   Map<String, String> body = {
//     'previous_member_id': '$previousMemberId',
//     'new_member_id': '$memberId',
//     'parent_id': '$parentId',
//   };
//
//   debugPrint('Sent Data is $body');
//   try {
//     var response = await loadingDialog(
//       context: context,
//       future: ApiService().post(
//         endPoint: ApiEndpoints.selectProjectionABMembers,
//         body: body,
//       ),
//     );
//
//     if (response != null && context.mounted) {
//       Map<String, dynamic> json = response;
//       DefaultModel responseData = DefaultModel.fromJson(json);
//
//       if (responseData.status == true) {
//       } else {
//         showError(context: context, message: responseData.message ?? 'Something Went Wrong');
//       }
//     }
//   } catch (e, s) {
//     ErrorHandler.catchError(e, s, true);
//   }
// }
}
