import 'package:bastarts_studio_users/utils/date_time_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dance_class.freezed.dart';
part 'dance_class.g.dart';

@freezed
abstract class DanceClass with _$DanceClass {
  const factory DanceClass({
    @Default('') String classId,
    required String teacherName,
    required String teacherSurname,
    @DateTimeToTimestampConverter() required DateTime startTime,
    @DateTimeToTimestampConverter() required DateTime endTime,
    String? imageDownloadUrl,
    @Default(15) int price,
    @Default(false) bool closed,
    @Default(false) bool videosSent,
    required bool requestPrepayment,
    String? description,

    //Emails
    List<Map<String, dynamic>>? pendingPaymentEmail,
    List<Map<String, dynamic>>? confirmPaymentEmail,
    List<Map<String, dynamic>>? registrationEmail,

    //Maybe someday this will have to be a List<String?>, but not today.
    String? connectedClassId,
    int? packagePrice,
  }) = _DanceClass;

  const DanceClass._();

  factory DanceClass.fromJson(Map<String, dynamic> json) => _$DanceClassFromJson(json);

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
}

class DateTimeToTimestampConverter implements JsonConverter<DateTime, String> {
  const DateTimeToTimestampConverter();

  //Flexible read to support legacy Firebase entries
  @override
  DateTime fromJson(Object json) => switch (json) {
    Timestamp t => t.toDate(),
    String s => DateTime.parse(s),

    _ => throw FormatException('Unsupported date value: $json'),
  };

  //Always write to string to support both Firebase and Sembast
  //(This also adds timezone ambiguity, so it can always be assumed Slovenian, regardless of device location)
  @override
  String toJson(DateTime object) => object.toIso8601String();
}
