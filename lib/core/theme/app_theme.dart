import 'package:flutter/material.dart';
import 'package:zindaonlineschool/core/constants/app_gaps.dart';
import '../constants/app_colors.dart';

class AppTheme {

  // static ThemeData darkTheme = ThemeData(
  //   useMaterial3: true,

  //   // Main Background
  //   scaffoldBackgroundColor: const Color.fromARGB(255, 9, 1, 35),

  //   // Primary Brand Color
  //   primaryColor: AppColors.primary,

  //   colorScheme: ColorScheme.dark(
  //     primary: AppColors.primary,
  //     secondary: AppColors.primary,
  //     surface: const Color(0xFF0D1B2A),
  //   ),

  //   // AppBar
  //   appBarTheme: const AppBarTheme(
  //     backgroundColor: Color(0xFF071426),
  //     foregroundColor: Colors.white,
  //     elevation: 0,
  //     centerTitle: true,
  //   ),

  //   // Text Theme
  //   textTheme: const TextTheme(
  //     bodyLarge: TextStyle(
  //       color: Colors.white,
  //     ),
  //     bodyMedium: TextStyle(
  //       color: Colors.white70,
  //     ),
  //     titleLarge: TextStyle(
  //       color: Colors.white,
  //       fontWeight: FontWeight.bold,
  //     ),
  //   ),

  //   // TextField Theme
  //   inputDecorationTheme: InputDecorationTheme(
  //     filled: true,

  //     // TextField background
  //     fillColor: const Color(0xFF10243A),

  //     contentPadding: const EdgeInsets.symmetric(
  //       horizontal: 18,
  //       vertical: 18,
  //     ),

  //     hintStyle: const TextStyle(
  //       color: Colors.white54,
  //     ),

  //     labelStyle: const TextStyle(
  //       color: Colors.white70,
  //     ),

  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(14),
  //       borderSide: BorderSide.none,
  //     ),

  //     enabledBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(14),
  //       borderSide: BorderSide.none,
  //     ),

  //     focusedBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(14),
  //       borderSide: BorderSide(
  //         color: AppColors.primary,
  //         width: 1.5,
  //       ),
  //     ),
  //   ),

  //   // Elevated Button Theme
  //   elevatedButtonTheme: ElevatedButtonThemeData(
  //     style: ElevatedButton.styleFrom(

  //       // Zinda Logo Color
  //       backgroundColor: AppColors.primary,

  //       foregroundColor: Colors.white,

  //       minimumSize: const Size(double.infinity, 55),

  //       elevation: 0,

  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(14),
  //       ),
  //     ),
  //   ),

  //   // Card Theme
  //   cardColor: const Color(0xFF10243A),

  //   // Icon Theme
  //   iconTheme: const IconThemeData(
  //     color: Colors.white,
  //   ),
  // );

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