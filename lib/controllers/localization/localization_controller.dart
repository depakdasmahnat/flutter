import 'package:flutter/material.dart';

import '../../core/localization/localization.dart';

class LocalizationProvider extends ChangeNotifier {
  Localization? _localization;

  Localization? get localization => _localization;

  void changeLocalization(Localization localization) {
    _localization = localization;
    notifyListeners();
  }
}
