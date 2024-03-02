// Dependencies (unchanged from previous response)

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadState extends ChangeNotifier {
  DownloadStatus status = DownloadStatus.idle;
  double progress = 0.0;
  String errorMessage = '';

  void startDownload(String? url, String? filename) async {
    status = DownloadStatus.downloading;
    progress = 0.0;
    errorMessage = '';
    notifyListeners();

    try {
      await downloadFile(url, filename);
      status = DownloadStatus.completed;
    } catch (error) {
      status = DownloadStatus.failed;
      errorMessage = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> downloadFile(String? url, String? filename) async {
    final uri = Uri.parse('$url');
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');

    try {
      final response = await Dio().get(
        uri.toString(),
        onReceiveProgress: (received, total) => progress = received / total,
      );

      if (response.statusCode == 200) {
        final sink = file.openWrite();
        debugPrint('download file: ${response.statusCode}');
        sink.add(response.data);
        await sink.close();
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }
}

enum DownloadStatus { idle, downloading, completed, failed }
