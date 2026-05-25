// import 'package:flutter/material.dart';

// class Responsive {

//   static double width(BuildContext context) {
//     return MediaQuery.of(context).size.width;
//   }

//   static double height(BuildContext context) {
//     return MediaQuery.of(context).size.height;
//   }

//   static bool isMobile(BuildContext context) {
//     return width(context) < 600;
//   }

//   static bool isTablet(BuildContext context) {
//     return width(context) >= 600 &&
//         width(context) < 1024;
//   }

//   static bool isDesktop(BuildContext context) {
//     return width(context) >= 1024;
//   }
// }
import 'package:flutter/material.dart';

/// Breakpoints and layout helpers for phone, tablet, and desktop/web.
class Responsive {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  static double width(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static double height(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  /// Width used for typography/layout inside [ResponsiveBody] (capped on tablet/desktop).
  static double contentWidth(BuildContext context) {
    final screenW = width(context);
    final maxW = maxContentWidth(context);
    if (!maxW.isFinite) return screenW;
    return screenW > maxW ? maxW : screenW;
  }

  /// Width / height as a fraction of content width / screen height.
  static double wp(BuildContext context, double fraction) =>
      contentWidth(context) * fraction;

  static double hp(BuildContext context, double fraction) =>
      spacing(context, fraction);

  static bool isMobile(BuildContext context) =>
      width(context) < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final w = width(context);
    return w >= mobileBreakpoint && w < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      width(context) >= tabletBreakpoint;

  /// Side [NavigationRail] on tablet and desktop; bottom bar on phone.
  static bool useNavigationRail(BuildContext context) =>
      width(context) >= mobileBreakpoint;

  /// Max width for form/content columns (centered on large screens).
  static double maxContentWidth(BuildContext context) {
    if (isDesktop(context)) return 920;
    if (isTablet(context)) return 720;
    return double.infinity;
  }

  /// Horizontal padding that scales by device class.
  static EdgeInsets screenPadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
    if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
    return EdgeInsets.symmetric(
      horizontal: width(context) * 0.04,
      vertical: height(context) * 0.02,
    );
  }

  /// Font size from width fraction, clamped so text stays readable.
  static double fontSize(
    BuildContext context,
    double widthFraction, {
    double min = 12,
    double max = 36,
  }) {
    return (width(context) * widthFraction).clamp(min, max);
  }

  /// Vertical spacing from height fraction, clamped.
  static double spacing(
    BuildContext context,
    double heightFraction, {
    double min = 4,
    double max = 56,
  }) {
    return (height(context) * heightFraction).clamp(min, max);
  }

  /// List/grid columns for card layouts.
  static int gridColumns(BuildContext context) {
    if (isDesktop(context)) return 3;
    if (isTablet(context)) return 2;
    return 1;
  }

  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }
}
