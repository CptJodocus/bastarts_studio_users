import 'package:bastarts_studio_users/domain/dance_class.dart';
import 'package:flutter/material.dart';

class SignUpClassInfo extends StatelessWidget {
  const SignUpClassInfo({super.key, required this.danceClass});

  final DanceClass danceClass;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(danceClass.fullTeacherNameNewLine, style: TextTheme.of(context).labelLarge),
        SizedBox(height: 8),
        Text(danceClass.date, style: TextTheme.of(context).bodySmall),
        Text(danceClass.classDuration, style: TextTheme.of(context).bodySmall),
        Text(danceClass.priceString, style: TextTheme.of(context).bodySmall),
      ],
    );
  }
}
