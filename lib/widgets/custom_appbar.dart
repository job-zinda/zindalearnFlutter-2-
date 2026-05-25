import 'package:flutter/material.dart';
import 'package:zindaonlineschool/core/constants/app_colors.dart';

import '../core/utils/responsive.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.white,
          fontSize: Responsive.fontSize(context, 0.05, min: 16, max: 22),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);
}