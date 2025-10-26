// ignore_for_file: deprecated_member_use

import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeManager {
  // Light Theme
  ThemeData lightThemeData = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: ColorManager.ecoGreen,
    scaffoldBackgroundColor: ColorManager.pureWhite,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorManager.ecoGreen,
      brightness: Brightness.light,
      primary: ColorManager.ecoGreen,
      secondary: ColorManager.skyBlue,
      background: ColorManager.pureWhite,
      onPrimary: ColorManager.pureWhite,
      onSecondary: ColorManager.darkElm,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: ColorManager.pureWhite,
        backgroundColor: ColorManager.ecoGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: ColorManager.pureWhite,
      elevation: 0,
      iconTheme: IconThemeData(color: ColorManager.darkElm),
      titleTextStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: ColorManager.darkElm,
        fontSize: 20,
      ),
    ),
    textTheme: _customTextTheme,
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      collapsedIconColor: ColorManager.hotCoral,
      iconColor: ColorManager.hotCoral,
    ),
    hintColor: Colors.black,
  );

  // Dark Theme
  ThemeData darkThemeData = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: ColorManager.ecoGreen,
    scaffoldBackgroundColor: ColorManager.darkElm,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorManager.ecoGreen,
      brightness: Brightness.dark,
      primary: ColorManager.ecoGreen,
      secondary: ColorManager.skyBlue,
      background: ColorManager.darkElm,
      onPrimary: ColorManager.pureWhite,
      onSecondary: ColorManager.pureWhite,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: ColorManager.pureWhite,
        backgroundColor: ColorManager.ecoGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: ColorManager.darkElm,
      elevation: 0,
      iconTheme: IconThemeData(color: ColorManager.pureWhite),
      titleTextStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: ColorManager.pureWhite,
        fontSize: 20,
      ),
    ),
    textTheme: _customTextTheme.apply(
      bodyColor: ColorManager.pureWhite,
      displayColor: ColorManager.pureWhite,
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      iconColor: ColorManager.pureWhite,
      textColor: ColorManager.pureWhite,
    ),
    expansionTileTheme: ExpansionTileThemeData(
      collapsedIconColor: ColorManager.skyBlue,
      iconColor: ColorManager.skyBlue,
    ),
    hintColor: Colors.white,
  );

  // Common TextTheme
  static final TextTheme _customTextTheme = GoogleFonts.poppinsTextTheme()
      .copyWith(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.5,
          color: ColorManager.darkElm,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: ColorManager.darkElm,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: ColorManager.darkElm,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: ColorManager.darkElm,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: ColorManager.darkElm,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ColorManager.darkElm,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: ColorManager.darkElm,
        ),
        labelLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: ColorManager.darkElm,
        ),
      );
}
