import 'package:flutter/material.dart';

import '../core/utils/responsive.dart';

class CustomLabel extends StatelessWidget {

  final String text;

  const CustomLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {

    final width =
        Responsive.width(context);

    return Align(

      alignment: Alignment.centerLeft,

      child: Padding(

        padding: EdgeInsets.only(
          bottom: width * 0.02,
        ),

        child: Text(

          text,

          style: TextStyle(

            fontSize: width * 0.035,

            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}