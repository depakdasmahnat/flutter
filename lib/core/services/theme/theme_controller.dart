import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/constant/colors.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';

import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/services/database/local_database.dart';
import 'package:mrwebbeast/utils/widgets/custom_bottom_sheet.dart';

import 'theme_picker.dart';

class ThemeController with ChangeNotifier {
  /// Theme...

  ThemeMode localTheme() {
    ThemeMode? themeMode;
    List<ThemeMode> list =
        ThemeMode.values.where((element) => element.name == LocalDatabase().themeMode).toList();
    if (list.haveData) {
      themeMode = list.first;
    }

    return themeMode ?? ThemeMode.system;
  }

  late ThemeMode _themeMode = localTheme();

  ThemeMode get themeMode => _themeMode;

  void changeTheme({required ThemeMode themeMode}) {
    _themeMode = themeMode;
    LocalDatabase().setThemeMode(mode: _themeMode);
    notifyListeners();
  }

  showThemePicker({required BuildContext context}) {
    return CustomBottomSheet.show(
      context: context,
      title: 'Change Theme',
      centerTitle: true,
      body: const ThemePicker(),
    );
  }
}

class AppThemes {
  ///1) Light Theme...

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      primaryColor: primaryColor,
      canvasColor: Colors.transparent,
      dividerTheme: DividerThemeData(color: Colors.grey.shade200),
      useMaterial3: false,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: createMaterialColor(primaryColor),
      ),
      appBarTheme: AppBarTheme(
        elevation: 1,
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontFamily: GoogleFonts.urbanist().fontFamily,
          fontWeight: FontWeight.w700,
        ),
      ),
      scaffoldBackgroundColor: Colors.grey.shade50,
      iconTheme: IconThemeData(color: Colors.grey.shade700),
    );
  }

  ///2) Dark Theme...
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      useMaterial3: true,
      canvasColor: Colors.transparent,
      fontFamily: GoogleFonts.urbanist().fontFamily,
      dividerTheme: DividerThemeData(color: Colors.grey.shade800, thickness: 1),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: createMaterialColor(primaryColor),
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontFamily: GoogleFonts.lato().fontFamily,
          fontWeight: FontWeight.w700,
        ),
      ),
      scaffoldBackgroundColor: Colors.black,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  ///3) Text Theme...
  static TextTheme textTheme(BuildContext context) {
    TextTheme defaultTheme = Theme.of(context).textTheme; // Get the default theme

    return TextTheme(
      displayLarge: defaultTheme.displayLarge?.copyWith(fontSize: 32),
      displayMedium: defaultTheme.displayMedium?.copyWith(fontSize: 24),
      displaySmall: defaultTheme.displaySmall?.copyWith(fontSize: 20),
      headlineLarge: defaultTheme.headlineLarge?.copyWith(fontSize: 28),
      headlineMedium: defaultTheme.headlineMedium?.copyWith(fontSize: 24),
      headlineSmall: defaultTheme.headlineSmall?.copyWith(fontSize: 20),
      titleLarge: defaultTheme.titleLarge?.copyWith(fontSize: 24),
      titleMedium: defaultTheme.titleMedium?.copyWith(fontSize: 20),
      titleSmall: defaultTheme.titleSmall?.copyWith(fontSize: 18),
      bodyLarge: defaultTheme.bodyLarge?.copyWith(fontSize: 18),
      bodyMedium: defaultTheme.bodyMedium?.copyWith(fontSize: 16),
      bodySmall: defaultTheme.bodySmall?.copyWith(fontSize: 14),
      labelLarge: defaultTheme.labelLarge?.copyWith(fontSize: 16),
      labelMedium: defaultTheme.labelMedium?.copyWith(fontSize: 14),
      labelSmall: defaultTheme.labelSmall?.copyWith(fontSize: 12),
    );
  }
}
