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
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: Responsive.spacing(context, 0.02, min: 6, max: 12),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 0.035, min: 12, max: 16),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
