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

    final width =
        Responsive.width(context);

    return AppBar(

      elevation: 0,

      centerTitle: true,

      backgroundColor: Colors.white,

      foregroundColor: Colors.white,

      title: Text(

        title,

        style: TextStyle(
          color: AppColors.white,

          fontSize:
          width * 0.05,

          fontWeight:
          FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);
}