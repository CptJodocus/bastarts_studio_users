import 'package:bastarts_studio_users/domain/dance_class.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'extra_class_provider.g.dart';

@riverpod
class ExtraClass extends _$ExtraClass {
  @override
  List<DanceClass> build() {
    return [];
  }

  void setExtraClassList(List<DanceClass> danceClasses) {
    state = danceClasses;
  }
}
