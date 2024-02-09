import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import "package:flutter_localizations/flutter_localizations.dart";

class AppLocalization {
  /// 1) lLocalizations Delegates...
  static localizationsDelegates() {
    return [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];
  }

  /// 2) Supported Languages...
  static supportedLocales() {
    return [
      const Locale('en', 'US'), // English
      const Locale('es', 'ES'), // Spanish
      // ...
    ];
  }
}
