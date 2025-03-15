import 'package:bastarts_studio_users/constants/test_class_list.dart';
import 'package:bastarts_studio_users/domain/dance_class.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeDanceClassRepository {
  final List<DanceClass> _danceClasses = kTestDanceClasses;

  Stream<List<DanceClass>> watchDanceClassList() async* {
    await Future.delayed(Duration(seconds: 2));
    yield _danceClasses;
  }

  Future<List<DanceClass>> fetchDanceClassList() async {
    await Future.delayed(Duration(seconds: 1));
    return _danceClasses;
  }

  Stream<DanceClass?> watchDanceClass(ClassID id) {
    return watchDanceClassList().map((danceClasses) => danceClasses.firstWhere((element) => element.classId == id));
  }
}

final danceClassRepositoryProvider = Provider<FakeDanceClassRepository>((ref) {
  return FakeDanceClassRepository();
});

final danceClassListProvider = StreamProvider.autoDispose<List<DanceClass>>((ref) {
  final danceClassRepository = ref.watch(danceClassRepositoryProvider);
  return danceClassRepository.watchDanceClassList();
});

final danceClassProvider = StreamProvider.autoDispose.family<DanceClass?, ClassID>((ref, id) {
  final danceClassRepository = ref.watch(danceClassRepositoryProvider);
  return danceClassRepository.watchDanceClass(id);
});
