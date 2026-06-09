import 'package:flutter/material.dart';
import 'package:zindaonlineschool/core/constants/app_colors.dart';

class AppTextStyles {

  static  TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.white, // Changed to white since Zinda uses a Dark Theme base
  );

  static  TextStyle subHeading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: Colors.white70,
  );

  static  TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static  TextStyle small = TextStyle(
    fontSize: 13,
    color: AppColors.grey,
  );
}