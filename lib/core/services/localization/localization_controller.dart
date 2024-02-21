import 'dart:ui' as ui;

import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../utils/widgets/custom_bottom_sheet.dart';
import 'language_picker.dart';

class LocalizationController extends ChangeNotifier {
  /// 1) Supported Languages...
  final Locale _defaultLocale = const Locale('en');
  List<Locale> supportedLocales = [
    const Locale('en'),
    const Locale('hi'),
    const Locale('ja'),
    const Locale('ru'),
    const Locale('zh'),
  ];

  /// 2) Current Language...

  late Locale? _locale = _defaultLocale;

  Locale? get locale => _locale;

  void changeLanguage({required Locale? locale}) {
    _locale = locale;
    debugPrint('Setting Language code: ${_locale?.languageCode} ');
    notifyListeners();
  }

  bool isSupported(Locale locale) =>
      supportedLocales.map((e) => e.languageCode).contains(locale.languageCode);

  showLanguagePicker({required BuildContext context}) {
    return CustomBottomSheet.show(
      context: context,
      title: 'Change Language',
      centerTitle: true,
      body: const LanguagePicker(),
    );
  }

  Future getDeviceLocals({bool? setDefault}) async {
    Locale currentLocale = ui.PlatformDispatcher.instance.locale;
    String? languageCode = currentLocale.languageCode;
    String? countryCode = '${currentLocale.countryCode}';
    debugPrint('Language code: $languageCode');
    debugPrint('Country code: $countryCode');
    if (isSupported(currentLocale) == true) {
      if (setDefault == true) {
        changeLanguage(locale: Locale(languageCode, countryCode));
      }
    } else {
      debugPrint("Language code: $languageCode Doesn't Supported");
    }
  }

  /// 3) Localizations Delegates...
  localizationsDelegates() {
    return [
      // AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];
  }
}
