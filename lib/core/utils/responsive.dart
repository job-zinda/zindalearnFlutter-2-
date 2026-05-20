import 'package:flutter/material.dart';

class Responsive {

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isMobile(BuildContext context) {
    return width(context) < 600;
  }

  static bool isTablet(BuildContext context) {
    return width(context) >= 600 &&
        width(context) < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return width(context) >= 1024;
  }
}