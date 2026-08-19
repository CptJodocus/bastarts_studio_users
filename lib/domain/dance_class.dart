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
    required this.requestPrepayment,
    this.description,
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
  final bool requestPrepayment;
  final String? description;

  //Maybe someday this will have to be a List<String?>, but not today.
  final String? connectedClassId;
  final int? packagePrice;

  String get fullTeacherNameInline => '$teacherName $teacherSurname';

  String get fullTeacherNameNewLine => '$teacherName\n$teacherSurname';
  String get nameAndDate => '$fullTeacherNameInline, $date';

  String get priceString => '$price€';

  String get classDuration {
    final formattedStartTime = kTimeFormat.format(startTime);
    final formattedEndTime = kTimeFormat.format(endTime);
    return '$formattedStartTime - $formattedEndTime';
  }

  String get columnDetails => '$fullTeacherNameInline\n$classDuration';
  String get inlineDetails => '$fullTeacherNameInline, $dateTime';

  String get dateTime => '${kDateFormat.format(startTime)}, $classDuration';
  String get date => kDateFormat.format(startTime);
  String get time => kTimeFormat.format(startTime);

  DanceClass copyWith({DateTime? newStartTime, String? newImageDownloadUrl}) {
    return DanceClass(
      classId: classId,
      teacherName: teacherName,
      teacherSurname: teacherSurname,
      startTime: newStartTime ?? startTime,
      endTime: endTime,
      price: price,
      imageDownloadUrl: newImageDownloadUrl ?? imageDownloadUrl,
      requestPrepayment: requestPrepayment,
      description: description,
    );
  }

  factory DanceClass.fromFirestore(Map<String, dynamic> map, String id) {
    return DanceClass(
      classId: id,
      teacherName: map["teacherName"],
      teacherSurname: map["teacherSurname"],
      description: map["description"],
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      imageDownloadUrl: map["imageDownloadUrl"],
      price: map["price"],
      requestPrepayment: map["requestPrepayment"],
      closed: map["closed"],
      videosSent: map['videosSent'],
      connectedClassId: map['connectedClassId'],
      packagePrice: map['packagePrice'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "teacherName": teacherName,
      "teacherSurname": teacherSurname,
      "description": description,
      "startTime": Timestamp.fromDate(startTime),
      "endTime": Timestamp.fromDate(endTime),
      "imageDownloadUrl": imageDownloadUrl,
      "price": price,
      "requestPrepayment": requestPrepayment,
      "closed": closed,
      "videosSent": videosSent,
      "connectedClassId": connectedClassId,
      "packagePrice": packagePrice,
    };
  }
}
