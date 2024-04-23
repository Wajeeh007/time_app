import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class ThemeHelper {

  static final textTheme = Theme.of(Get.context!).textTheme;
  
  static ThemeData lightTheme = ThemeData.light(
    useMaterial3: true,
  ).copyWith(
    brightness: Brightness.light,
    textTheme: TextThemes.textTheme(color: primaryDarkGrey),
    appBarTheme: const AppBarTheme(
        color: Colors.white
    ),
    primaryColor: primaryPurple,
    indicatorColor: primaryPurple,
    unselectedWidgetColor: primaryGrey,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      circularTrackColor: primaryBlack
    ),
    splashColor: Colors.transparent,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
  );

  static ThemeData darkTheme = ThemeData.dark(
    useMaterial3: true,
  ).copyWith(
    primaryColor: primaryPurple,
    brightness: Brightness.dark,
    indicatorColor: primaryPurple,
    appBarTheme: const AppBarTheme(
      color: primaryBlack
    ),
    unselectedWidgetColor: primaryGrey,
    splashColor: Colors.transparent,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      circularTrackColor: Colors.white,
    ),
    textTheme: TextThemes.textTheme(color: Colors.white),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlack,
      brightness: Brightness.dark,
    ),
  );
}

class TextThemes {

  static TextTheme textTheme({required Color color}) => TextTheme(
    bodyLarge: TextStyle(
      color: color,
      fontSize: 25,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      color: color,
      fontSize: 17,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      color: color,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    labelMedium: TextStyle(
      color: color,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 2.8
    ),
    labelSmall: TextStyle(
      color: color,
      fontSize: 10,
      fontWeight: FontWeight.w400,
      height: 2.8
    ),
  ).apply(
    fontFamily: GoogleFonts.nunitoSans().fontFamily,
  );
}