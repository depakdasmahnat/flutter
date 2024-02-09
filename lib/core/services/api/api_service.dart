import 'dart:convert';
import 'dart:core';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../../main.dart';
import '../../../utils/widgets/widgets.dart';
import '../../config/app_config.dart';
import '../database/local_database.dart';
import 'exception_handler.dart';

String queryParameter({required Map<String, String>? body}) {
  String formattedData = "";
  List<String>? bodyList = [];

  if (body != null) {
    body.forEach((key, value) {
      bodyList.add("&$key=$value");
    });
    formattedData = bodyList.join("").replaceFirst("&", "?");
  }
  debugPrint("body $formattedData");
  return formattedData;
}

class ApiService {
  static const int timeOutDuration = 35; //Seconds
  Map<String, String> defaultHeaders() {
    return {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
  }

  Future<Uint8List?> getMarkerNetworkImage(String imageUrl) async {
    Uint8List? image;
    http.Response? response;
    if (imageUrl.isNotEmpty) {
      response = await http.get(Uri.parse(imageUrl));
    }
    if (response?.statusCode == 200) {
      image = response?.bodyBytes;
    }
    Uint8List? resizedImageMarker;
    if (image != null) {
      final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
        image.buffer.asUint8List(),
        targetHeight: 100,
        targetWidth: 100,
      );
      final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
      final ByteData? byteData = await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
      resizedImageMarker = byteData?.buffer.asUint8List();
      // resizedImageMarker = await addBorderRadiusToImage(imageData: resizedImageMarker, size: 100);
    }

    return resizedImageMarker;
  }

  Future<Uint8List?> addBorderRadiusToImage({required Uint8List? imageData, required int size}) async {
    if (imageData == null) {
      return null;
    }

    final ui.Codec imageCodec = await ui.instantiateImageCodec(imageData);
    final ui.FrameInfo frameInfo = await imageCodec.getNextFrame();
    final ui.Image image = frameInfo.image;

    final recorder = ui.PictureRecorder();
    final canvas =
        Canvas(recorder, Rect.fromPoints(const Offset(0.0, 0.0), Offset(size.toDouble(), size.toDouble())));

    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.transparent; // You can set a background color here if needed.

    canvas.drawCircle(
      Offset(size.toDouble() / 2, size.toDouble() / 2),
      size.toDouble() / 2,
      paint,
    );

    // This ensures that the circular image will have a transparent background.
    paint.blendMode = BlendMode.srcIn;

    final double scale = image.width.toDouble() / image.height.toDouble();

    double srcWidth = image.width.toDouble();
    double srcHeight = image.height.toDouble();
    double dstWidth, dstHeight;
    double offsetX = 0, offsetY = 0;

    if (scale > 1.0) {
      dstWidth = size.toDouble();
      dstHeight = size / scale;
      offsetY = (size - dstHeight) / 2;
    } else {
      dstWidth = size * scale;
      dstHeight = size.toDouble();
      offsetX = (size - dstWidth) / 2;
    }

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, srcWidth, srcHeight),
      Rect.fromLTWH(offsetX, offsetY, dstWidth, dstHeight),
      paint,
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size, size);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData?.buffer.asUint8List();
  }

  ///1) Get Method...

  Future<dynamic> get({
    required BuildContext context,
    Map<String, String>? headers,
    required String endPoint,
    String? baseUrl,
  }) async {
    String url = (baseUrl ?? AppConfig.baseUrl) + endPoint;
    var uri = Uri.parse(url);
    debugPrint("$uri");

    try {
      var response = await http.get(uri, headers: headers).timeout(const Duration(seconds: timeOutDuration));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);

      return _processResponse(response: response);
    } catch (e, s) {
      String error = e.toString();
      if (e is AppException) {
        error = e.message ?? "Something went wrong";
      }

      debugPrint("Error is $e");
      debugPrint("Error Stack is $s");

      showSnackBar(context: context, text: error, color: Colors.red, icon: Icons.error);
    }
  }

  ///2) POST Method...

  Future<dynamic> post({
    Map<String, String>? headers,
    required String endPoint,
    required BuildContext context,
    String? baseUrl,
    Object? body,
  }) async {
    String url = (baseUrl ?? AppConfig.baseUrl) + endPoint;
    var uri = Uri.parse(url);
    debugPrint("url $uri");

    try {
      final response = await http
          .post(uri, headers: headers, body: body)
          .timeout(const Duration(seconds: timeOutDuration));
      debugPrint("API Status Code =>  ${response.statusCode}");
      debugPrint("API Response =>  ${response.body}");

      return _processResponse(response: response);
    } catch (e, s) {
      String error = e.toString();
      if (e is AppException) {
        error = e.message ?? "Something went wrong";
      }

      debugPrint("Error is $e");
      debugPrint("Error Stack is $s");

      showSnackBar(context: context, text: error, color: Colors.red, icon: Icons.error);
    }
  }

  ///3) PUT Method...

  Future<dynamic> put({
    required BuildContext context,
    required String endPoint,
    String? baseUrl,
    Map<String, String>? headers,
    Object? body,
  }) async {
    String url = (baseUrl ?? AppConfig.baseUrl) + endPoint;
    var uri = Uri.parse(url);

    try {
      final response = body == null
          ? await http.put(uri, headers: headers)
          : await http
              .put(uri, headers: headers, body: body)
              .timeout(const Duration(seconds: timeOutDuration));
      debugPrint(response.body);

      return _processResponse(response: response);
    } catch (e, s) {
      String error = e.toString();
      if (e is AppException) {
        error = e.message ?? "Something went wrong";
      }

      debugPrint("Error is $e");
      debugPrint("Error Stack is $s");

      showSnackBar(context: context, text: error, color: Colors.red, icon: Icons.error);
    }
  }

  ///4) MultiPart  Method...

  Future<dynamic> multiPart({
    required BuildContext context,
    List<MultiPartData?>? multipartFile,
    Map<String, String>? headers,
    required Map<String, String> body,
    required String endPoint,
    String? baseUrl,
  }) async {
    String url = (baseUrl ?? AppConfig.baseUrl) + endPoint;
    var uri = Uri.parse(url);
    debugPrint("API Url => $uri");
    try {
      var defaultHeaders = {'Authorization': 'Bearer ${LocalDatabase().accessToken}'};
      var request = http.MultipartRequest('POST', uri);
      request.fields.addAll(body);

      if (multipartFile != null) {
        for (var element in multipartFile) {
          debugPrint("Multipart... Field ${element?.field}: FilePath ${element?.filePath}");
          request.files.add(await http.MultipartFile.fromPath('${element?.field}', '${element?.filePath}'));
        }
      }

      request.headers.addAll(headers ?? defaultHeaders);

      http.StreamedResponse response = await request.send();

      // debugPrint("API Status Code =>  ${response.statusCode}");
      // debugPrint("API Response =>  ${response.body}");
      return await response.stream.bytesToString();
    } catch (e, s) {
      String error = e.toString();
      if (e is AppException) {
        error = e.message ?? "Something went wrong";
      }

      debugPrint("Error is $e");
      debugPrint("Error Stack is $s");

      showSnackBar(context: context, text: error, color: Colors.red, icon: Icons.error);
    }
  }

  dynamic _processResponse({
    required http.Response response,
  }) {
    String message = 'Oops! something went wrong';

    BuildContext? context = MyApp.navigatorKey.currentContext;
    showError() {
      if (context != null) {
        showSnackBar(context: context, text: message, color: Colors.red, icon: Icons.error_outline);
      }
    }

    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 201:
        return jsonDecode(response.body);
      case 400:
        message = "Oops! something went wrong";
        showError();
        throw AppException(message, response.request!.url.toString());

      case 401:
        message = "Unauthorised User";
        showError();
        throw AppException(message, response.request!.url.toString());
        case 403:
        message = "Forbidden Access";
        showError();
        throw UnAuthorizedException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 404:
        message = "API not found";
        showError();
        throw AppException(message, response.request!.url.toString());
      case 422:
        message = "Oops! something went wrong";
        showError();
        throw AppException(message, response.request!.url.toString());
      case 429:
        message = "Too Many Requests";
        showError();
        break;
      case 500:
        message = "Server Error";
        showError();
        break;
      case 502:
        message = "Bad Gateway 502";
        showError();
        throw AppException(message, response.request!.url.toString());
      case 503:
        message = "Service Unavailable";
        showError();
        throw AppException(message, response.request!.url.toString());

      case 504:
        message = "Server Timeout";
        showError();
        throw AppException(message, response.request!.url.toString());

      default:
        message = "Unknown Error";
        showError();
        throw FetchDataException(
            'Error occurred with code : ${response.statusCode}', response.request!.url.toString());
    }
  }
}

class MultiPartData {
  MultiPartData({
    required this.field,
    required this.filePath,
  });

  String? field;
  String? filePath;

  factory MultiPartData.fromJson(Map<String, dynamic> json) => MultiPartData(
        field: json["field"],
        filePath: json["filePath"],
      );

  Map<String, dynamic> toJson() => {
        "field": field,
        "filePath": filePath,
      };
}
