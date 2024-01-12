import 'package:flutter/material.dart';

class DashboardController extends ChangeNotifier {
  final int _defaultDashBoardIndex = 0;

  late int _dashBoardIndex = _defaultDashBoardIndex;

  int get dashBoardIndex => _dashBoardIndex;

  changeDashBoardIndex({int? index}) {
    _dashBoardIndex = index ?? _dashBoardIndex;

    notifyListeners();
  }
}
