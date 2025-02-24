import 'package:bastarts_studio_users/presentation/widgets/responsive_center.dart';
import 'package:flutter/material.dart';

class ResponsiveTwoColumnLayout extends StatelessWidget {
  const ResponsiveTwoColumnLayout({
    super.key,
    required this.startContent,
    required this.endContent,
    required this.spacing,
    this.columnContent,
    this.rowAlignment,
    this.wrapRowEndWithResponsiveCenter = false,
  });

  final Widget startContent;
  final Widget endContent;
  final Widget? columnContent;
  final MainAxisAlignment? rowAlignment;
  final double spacing;

  final bool wrapRowEndWithResponsiveCenter;

  @override
  Widget build(BuildContext context) {
    final rowEndWidget =
        wrapRowEndWithResponsiveCenter ? ResponsiveCenter(maxContentWidth: 400, child: endContent) : endContent;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: rowAlignment ?? MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: spacing,
            children: [Flexible(child: startContent), Flexible(child: rowEndWidget)],
          );
        } else {
          if (columnContent != null) {
            return ConstrainedBox(constraints: BoxConstraints(maxHeight: 70), child: columnContent);
          } else {
            return Column(
              spacing: spacing,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [startContent, endContent],
            );
          }
        }
      },
    );
  }
}
