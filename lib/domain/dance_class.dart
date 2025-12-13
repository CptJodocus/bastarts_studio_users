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
    this.price = 12,
    this.closed = false,
    this.videosSent = false,
    this.connectedClassId,
    this.packagePrice,
  });

  final ClassID classId;
  final String teacherName;
  final String teacherSurname;
  final DateTime startTime;
  final DateTime endTime;
  final String? imageDownloadUrl;
  final int price;
  final bool closed;
  final bool videosSent;

  //Maybe someday this will have to be a List<String?>, but not today.
  final String? connectedClassId;
  final int? packagePrice;

  String get fullTeacherNameInline => '$teacherName $teacherSurname';

  String get fullTeacherNameNewLine => '$teacherName\n$teacherSurname';

  String get priceString => '$price€';

  String get classDuration {
    final formattedStartTime = kTimeFormat.format(startTime);
    final formattedEndTime = kTimeFormat.format(endTime);
    return '$formattedStartTime - $formattedEndTime';
  }

  String get columnDetails => '$fullTeacherNameInline\n$classDuration';
  String get inlineDetails => '$fullTeacherNameInline, $dateTime';

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
      closed: map["closed"],
      videosSent: map['videosSent'],
      connectedClassId: map['connectedClassId'],
      packagePrice: map['packagePrice'],
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
