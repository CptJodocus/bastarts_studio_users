import 'package:bastarts_studio_users/domain/dance_class.dart';
import 'package:bastarts_studio_users/presentation/widgets/extra_registrations_field.dart';
import 'package:flutter/material.dart';

class SignUpClassInfo extends StatelessWidget {
  const SignUpClassInfo({super.key, required this.danceClass});

  final DanceClass danceClass;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(danceClass.fullTeacherNameNewLine, style: TextTheme.of(context).titleLarge),
        SizedBox(height: 8),
        Text(danceClass.date, style: TextTheme.of(context).bodySmall),
        Text(danceClass.classDuration, style: TextTheme.of(context).bodySmall),
        Text(danceClass.priceString, style: TextTheme.of(context).bodySmall),
        SizedBox(height: 16),
        Text(danceClass.description ?? '', style: TextTheme.of(context).labelMedium),
        SizedBox(height: 32),
        ExtraRegistrationsField(danceClass),
      ],
    );
  }
}
