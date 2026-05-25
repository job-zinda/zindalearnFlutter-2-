import 'package:flutter/material.dart';

import '../core/utils/responsive.dart';

/// Centers content and limits width on tablet/desktop so UI does not stretch edge-to-edge.
class ResponsiveBody extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool alignTop;

  const ResponsiveBody({
    super.key,
    required this.child,
    this.padding,
    this.alignTop = true,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignTop ? Alignment.topCenter : Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Responsive.maxContentWidth(context),
        ),
        child: Padding(
          padding: padding ?? Responsive.screenPadding(context),
          child: child,
        ),
      ),
    );
  }
}
