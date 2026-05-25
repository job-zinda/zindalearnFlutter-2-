
import 'package:flutter/material.dart';

import '../core/utils/responsive.dart';

class CustomButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      width: double.infinity,
      height: Responsive.value(context, mobile: 52.0, tablet: 56.0, desktop: 56.0),

      child: ElevatedButton(

        onPressed:
            isLoading ? null : onPressed,

        child: isLoading

            ? const SizedBox(
                height: 22,
                width: 22,

                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )

            : Text(
                text,

                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 0.04, min: 14, max: 18),
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}