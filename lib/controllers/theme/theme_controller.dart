import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constant/colors.dart';

MaterialColor createMaterialColor(Color color) {
  Map<int, Color> swatch = {
    50: color.withOpacity(0.1),
    100: color.withOpacity(0.2),
    200: color.withOpacity(0.3),
    300: color.withOpacity(0.4),
    400: color.withOpacity(0.5),
    500: color.withOpacity(0.6),
    600: color.withOpacity(0.7),
    700: color.withOpacity(0.8),
    800: color.withOpacity(0.9),
    900: color.withOpacity(1.0),
  };
  return MaterialColor(color.value, swatch);
}

class ThemeController {
  static ThemeData lightTheme() => ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
        canvasColor: Colors.transparent,
        useMaterial3: false,
        textTheme: TextTheme(
          titleLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: GoogleFonts.mulish().fontFamily,
              color: Colors.black),
          titleMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: GoogleFonts.mulish().fontFamily,
              color: Colors.black),
          titleSmall: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        fontFamily: GoogleFonts.outfit().fontFamily,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: createMaterialColor(primaryColor)),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: GoogleFonts.outfit().fontFamily,
            fontWeight: FontWeight.w700,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey.shade700),
      );
}
