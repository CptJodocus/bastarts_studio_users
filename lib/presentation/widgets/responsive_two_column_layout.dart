import 'package:flutter/material.dart';

class ResponsiveTwoColumnLayout extends StatelessWidget {
  const ResponsiveTwoColumnLayout({
    super.key,
    required this.startContent,
    required this.endContent,
    required this.spacing,
    this.columnContent,
    this.rowAlignment,
  });

  final Widget startContent;
  final Widget endContent;
  final Widget? columnContent;
  final MainAxisAlignment? rowAlignment;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: rowAlignment ?? MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: spacing,
            children: [Flexible(child: startContent), Flexible(child: endContent)],
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
