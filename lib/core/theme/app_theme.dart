import 'package:flutter/material.dart';
import 'package:zindaonlineschool/core/constants/app_gaps.dart';
import '../constants/app_colors.dart';

class AppTheme {

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.cardFill,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBarFill,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardFill,
      contentPadding: const EdgeInsets.all(18),
      hintStyle: const TextStyle(color: Colors.white54),
      labelStyle: const TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppGaps.radius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppGaps.radius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppGaps.radius),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        minimumSize: const Size(double.infinity, AppGaps.buttonHeight),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppGaps.radius),
        ),
      ),
    ),

    cardColor: AppColors.cardFill,
    iconTheme: const IconThemeData(color: AppColors.white),
  );
}