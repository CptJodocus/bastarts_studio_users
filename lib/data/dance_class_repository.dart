import 'dart:convert';

import 'package:bastarts_studio_users/domain/dance_class.dart';
import 'package:bastarts_studio_users/domain/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dance_class_repository.g.dart';

class DanceClassRepository {
  DanceClassRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Stream<List<DanceClass>> watchDanceClassList() {
    final ref = _danceCollectionRef();
    final classes = ref.where("closed", isEqualTo: false);

    return classes.snapshots().map((snapshot) => snapshot.docs.map((document) => document.data()).toList());
  }

  Stream<DanceClass?> watchDanceClass(ClassID id) {
    final ref = _danceClassRef(id);
    return ref.snapshots().map((event) => event.data());
  }

  Future<DanceClass?> fetchDanceClass(ClassID id) async {
    final ref = _danceClassRef(id);
    final snapshot = await ref.get();
    return snapshot.data();
  }

  Stream<int> watchDanceClassRegistrations(ClassID id) {
    final ref = _studentsCollectionRef(id);
    return ref.snapshots().map((event) => event.docs.map((e) => e.data()).toList().length);
  }

  Future<void> addFakeRegistration(String danceClassId, String firstName, String lastName, String email) async {
    final bytes = utf8.encode(email);
    final uuid = sha1.convert(bytes);
    final student = Student(uuid: uuid.toString(), firstName: firstName, lastName: lastName, email: email);

    await _studentsCollectionRef(danceClassId).add(student);
  }

  CollectionReference<DanceClass> _danceCollectionRef() => _firestore
      .collection('classes')
      .withConverter(
        fromFirestore: (snapshot, options) => DanceClass.fromFirestore(snapshot.data()!, snapshot.id),
        toFirestore: (value, options) => value.toFirestore(),
      );

  CollectionReference<Student> _studentsCollectionRef(ClassID id) => _firestore
      .collection('classes/$id/students')
      .withConverter(
        fromFirestore: (snapshot, options) => Student.fromJson(snapshot.data()!),
        toFirestore: (value, options) => value.toJson(),
      );

  DocumentReference<DanceClass> _danceClassRef(ClassID id) => _firestore
      .doc('classes/$id')
      .withConverter(
        fromFirestore: (snapshot, options) => DanceClass.fromFirestore(snapshot.data()!, snapshot.id),
        toFirestore: (value, options) => value.toFirestore(),
      );

  DocumentReference<Student> _studentRef(ClassID id, String uuid) => _firestore
      .doc('classes/$id/students/$uuid')
      .withConverter(
        fromFirestore: (snapshot, options) => Student.fromJson(snapshot.data()!),
        toFirestore: (value, options) => value.toJson(),
      );
}

@Riverpod(keepAlive: true)
DanceClassRepository danceClassRepository(Ref ref) {
  return DanceClassRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<DanceClass>> danceClassesStream(Ref ref) {
  final repository = ref.watch(danceClassRepositoryProvider);
  return repository.watchDanceClassList();
}

@riverpod
Stream<DanceClass?> danceClassStream(Ref ref, ClassID id) {
  final repository = ref.watch(danceClassRepositoryProvider);
  return repository.watchDanceClass(id);
}

@riverpod
Future<DanceClass?> danceClassFuture(Ref ref, ClassID id) {
  final repository = ref.watch(danceClassRepositoryProvider);
  return repository.fetchDanceClass(id);
}

@riverpod
Stream<int> studentStream(Ref ref, ClassID id) {
  final repository = ref.watch(danceClassRepositoryProvider);
  return repository.watchDanceClassRegistrations(id);
}
