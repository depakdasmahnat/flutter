import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mrwebbeast/controllers/member/member_auth_controller.dart';
import 'package:mrwebbeast/core/services/api/api_service.dart';
import 'package:mrwebbeast/core/services/database/local_database.dart';
import 'package:mrwebbeast/models/default_model.dart';
import 'package:provider/provider.dart';

import '../../../app.dart';
import '../../../utils/widgets/widgets.dart';

class ApiException implements Exception {
  final String? url;
  final int? statusCode;
  final StackTrace? stackTrace;
  final String message;
  final dynamic originalException;

  ApiException({
    this.url,
    this.statusCode,
    this.stackTrace,
    required this.message,
    required this.originalException,
  });

  /// This is Error Handling of Error...

  void errorHandle({
    bool? showError = true,
    bool logError = true,
    bool reportError = true,
    String? message,
  }) {
    if (logError) {
      FirebaseCrashlytics.instance.recordError(originalException, stackTrace ?? StackTrace.current);
    }

    if (showError ?? true) {
      BuildContext? context = MyApp.navigatorKey.currentState?.context;
      if (context != null) {
        showSnackBar(context: context, text: message ?? this.message, color: Colors.red);
      } else {
        debugPrint('App context does not found to show Error Popup');
      }
    }

    if (reportError) {
      // TODO: Report error to a remote error reporting service.
      FirebaseCrashlytics.instance.log(message ?? this.message);
    }
  }
}

class ErrorHandler {
  static Future<dynamic> processResponse({
    required http.BaseResponse response,
    required bool? showError,
  }) async {
    String? body;
    if (response is http.Response) {
      body = response.body;
    } else if (response is http.StreamedResponse) {
      body = await response.stream.bytesToString();
    }

    String url = Uri.parse('${response.request?.url}').toString();
    int statusCode = response.statusCode;
    String message;

    try {
      Map<String, dynamic> json = jsonDecode('$body');
      DefaultModel responseBody = DefaultModel.fromJson(json);
      message = responseBody.message ?? getErrorMessage(statusCode);
      if (responseBody.status == false) {
        showError = true;
      }
    } catch (e) {
      message = getErrorMessage(statusCode);
      debugPrint('Error ${e.toString()}');
    }

    ApiException throwException({String? error}) {
      return throw ApiException(
        url: url,
        message: error ?? message,
        statusCode: response.statusCode,
        originalException: body,
      );
    }

    log('API Url => $url');
    log('Status Code => $statusCode');

    log('Header => ${ApiService().defaultHeaders()}');
    log('Message => $message');
    log('Response => $body');

    try {
      switch (response.statusCode) {
        case 200:
          return jsonDecode(body ?? '');
        case 201:
          return jsonDecode(body ?? '');
        case 401:
          reAuth(message);
          throwException();
          break;
        case 403:
          reAuth(message);
          throwException();
          break;
        default:
          throwException();
      }
    } catch (e, s) {
      if (e is ApiException) {
        e.errorHandle(showError: showError);
      } else {
        catchError(e, s, showError);
      }
    }
  }

  static reAuth(String message) {
    BuildContext? context = MyApp.navigatorKey.currentContext;
    showError() {
      if (context != null) {
        showSnackBar(context: context, text: message, color: Colors.red, icon: Icons.error_outline);
      }
    }

    if (context != null) {
      showError();
      context.read<MemberAuthControllers>().logOut(context: context, message: message, color: Colors.red);
    }
  }

  static catchError(Object e, StackTrace s, bool? showError) {
    ApiException(message: e.toString(), originalException: e, stackTrace: s)
        .errorHandle(showError: showError);
  }

  static String getRequestStatus(int statusCode) {
    final status = apiStatues[statusCode];
    String value = status?['name'] ?? 'Unknown error with name code $statusCode';
    return value;
  }

  static String getErrorMessage(int statusCode) {
    final status = apiStatues[statusCode];
    String value = status?['message'] ?? 'Unknown error with name code $statusCode';
    return value;
  }

  static final Map<int, Map<String, String>> apiStatues = {
    200: {
      'name': 'OK',
      'message': 'The request completed successfully',
    },
    201: {
      'name': 'Created',
      'message': 'The resource was successfully created',
    },
    204: {
      'name': 'NoContent',
      'message': 'The request completed successfully but returned no content',
    },
    400: {
      'name': 'BadRequest',
      'message': 'The request was invalid',
    },
    401: {
      'name': 'Unauthorized',
      'message': 'Authentication failed',
    },
    403: {
      'name': 'Forbidden',
      'message': 'The request is not authorized',
    },
    404: {
      'name': 'NotFound',
      'message': 'The requested resource was not found',
    },
    405: {
      'name': 'MethodNotAllowed',
      'message': 'The request method is not allowed for the requested resource',
    },
    409: {
      'name': 'Conflict',
      'message': 'The request conflicts with the current state of the resource',
    },
    429: {
      'name': 'TooManyRequests',
      'message': "Server can't handel Too Many Requests",
    },
    500: {
      'name': 'InternalServerError',
      'message': 'An internal server error occurred',
    },
    501: {
      'name': 'NotImplemented',
      'message': 'The request method is not implemented by the server',
    },
    502: {
      'name': 'BadGateway',
      'message': 'Bad Gateway',
    },
    503: {
      'name': 'Service Unavailable',
      'message': 'Service Unavailable',
    },
    504: {
      'name': 'Server Timeout',
      'message': 'Server Time out',
    },
    // add more error codes and messages as needed
  };
}
