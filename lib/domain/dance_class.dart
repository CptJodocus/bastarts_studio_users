import 'dart:io';

import 'package:bastarts_studio_users/utils/date_time_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

typedef ClassID = String;

class DanceClass {
  const DanceClass({
    required this.classId,
    required this.teacherName,
    required this.teacherSurname,
    required this.startTime,
    required this.endTime,
    this.imageDownloadUrl,
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
  final String? imageDownloadUrl;

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

  factory DanceClass.fromFirestore(Map<String, dynamic> map, String id) {
    return DanceClass(
      classId: id,
      teacherName: map["teacherName"],
      teacherSurname: map["teacherSurname"],
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      imageDownloadUrl: map["imageDownloadUrl"],
      price: map["price"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      //Wondering if this is going to break something in the future, because I removed the "id"
      "teacherName": teacherName,
      "teacherSurname": teacherSurname,
      "startTime": Timestamp.fromDate(startTime),
      "endTime": Timestamp.fromDate(endTime),
      "imageDownloadUrl": imageDownloadUrl,
      "price": price,
    };
  }
}
