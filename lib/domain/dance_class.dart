import 'dart:io';

import 'package:bastarts_studio_users/utils/date_time_format.dart';

typedef ClassID = String;

class DanceClass {
  const DanceClass({
    required this.classId,
    required this.teacherName,
    required this.teacherSurname,
    required this.startTime,
    required this.endTime,
    required this.imageUri,
    this.teacherImageRegistrationCard,
    this.price = 12,
  });

  final ClassID classId;
  final String teacherName;
  final String teacherSurname;
  final DateTime startTime;
  final DateTime endTime;
  final File? teacherImageRegistrationCard;
  final int price;
  final String imageUri;

  String get fullTeacherNameInline => '$teacherName $teacherSurname';

  String get fullTeacherNameNewLine => '$teacherName\n$teacherSurname';

  String get priceString => '$price€';

  String get classDuration {
    final formattedStartTime = kTimeFormat.format(startTime);
    final formattedEndTime = kTimeFormat.format(endTime);
    return '$formattedStartTime - $formattedEndTime';
  }

  String get columnDetails => '$fullTeacherNameInline\n$classDuration';

  String get dateTime => '${kDateFormat.format(startTime)}, $classDuration';
  String get date => kDateNameFormat.format(startTime);
  String get time => kTimeFormat.format(startTime);
}
