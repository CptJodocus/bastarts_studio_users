import 'dart:convert';

import 'package:bastarts_studio_users/domain/dance_class.dart';
import 'package:bastarts_studio_users/domain/student.dart';
import 'package:bastarts_studio_users/utils/string_capitalization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

part 'dance_class_repository.g.dart';

class DanceClassRepository {
  DanceClassRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Stream<List<DanceClass>> watchDanceClassList() {
    final ref = _danceCollectionRef();
    final classes = ref.where("closed", isEqualTo: false);

    return classes.snapshots().map((snapshot) => snapshot.docs.map((document) => document.data()).toList());
  }

  Stream<DanceClass?> watchDanceClass(String id) {
    final ref = _danceClassRef(id);
    return ref.snapshots().map((event) => event.data());
  }

  Future<DanceClass?> fetchDanceClass(String id) async {
    final ref = _danceClassRef(id);
    final snapshot = await ref.get();
    return snapshot.data();
  }

  Stream<int> watchDanceClassRegistrations(String id) {
    final ref = _studentsCollectionRef(id);
    return ref.snapshots().map((event) => event.docs.map((e) => e.data()).toList().length);
  }

  Future<bool> alreadyRegistered(String classId, String email) {
    final uuid = emailToUuid(email);

    final studentRef = _studentRef(classId, uuid);
    return studentRef.get().then((value) => value.exists);
  }

  String emailToUuid(String email) {
    final bytes = utf8.encode(email);
    final uuid = sha1.convert(bytes);
    return uuid.toString();
  }

  Future<void> register({
    required String danceClassId,
    required String firstName,
    required String lastName,
    required String email,
    String? parentName,
    String? parentSurname,
    String? parentEmail,
  }) async {
    final studentId = emailToUuid(email);

    final student = Student(
      uuid: studentId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      parentName: parentName,
      parentSurname: parentSurname,
      parentEmail: parentEmail,
      paid: false,
    );

    await _studentRef(danceClassId, studentId).set(student);
  }

  void _replaceHandlebar(Document doc, String token, String replacement) {
    final offsets = doc.search(token, caseSensitive: true);

    for (var offset in offsets.reversed) {
      final style = doc.collectStyle(offset, token.length);
      final attributes = {
        for (final a in style.values)
          if (a.scope == AttributeScope.inline) a.key: a.value,
      };
      doc.compose(
        Delta()
          ..retain(offset)
          ..delete(token.length)
          ..insert(replacement, attributes),
        .local,
      );
    }
  }

  String _docToProcessedHtml(Document doc, {required DanceClass danceClass, required String firstName}) {
    final replacements = {
      '{{name}}': firstName.capitalize(),
      '{{classDetails}}': danceClass.inlineDetails,
      '{{price}}': danceClass.priceString,
      '{{packageInfo}}': danceClass.connectedClassId != null
          ? 'Za obisk obeh tečajev v paketu je prispevek skupaj ${danceClass.packagePrice}€.'
          : '',
      '{{purpose}}': 'Plačilo tečaj - ${danceClass.date}',
    };

    replacements.forEach(
      (key, value) => _replaceHandlebar(doc, key, value),
    );
    final converter = QuillDeltaToHtmlConverter(doc.toDelta().toJson(), .forEmail());
    final html = converter.convert();
    return html;
  }

  Future<void> sendRegistrationEmail({
    required DanceClass danceClass,
    required String firstName,
    required String email,
    String? parentEmail,
  }) async {
    final mailRef = _firestore.collection('mail');

    assert(danceClass.registrationEmail != null);

    Document doc = Document.fromJson(danceClass.registrationEmail!);

    final html = _docToProcessedHtml(doc, danceClass: danceClass, firstName: firstName);

    Map<String, dynamic> emailMap = {
      'to': email,

      'message': {
        'subject': 'Prijava na BastArts Studio Open Class - ${danceClass.fullTeacherNameInline}',
        'html': html,
      },
    };

    if (parentEmail != null) {
      emailMap.addAll({'cc': parentEmail});
    }

    await mailRef.add(emailMap);
  }

  Future<void> sendPaymentRequestEmail({
    required DanceClass danceClass,
    required String firstName,
    required String email,
    String? parentEmail,
  }) async {
    final mailRef = _firestore.collection('mail');

    Document doc = Document.fromJson(danceClass.pendingPaymentEmail!);

    final html = _docToProcessedHtml(doc, danceClass: danceClass, firstName: firstName);

    Map<String, dynamic> emailMap = {
      'to': email,

      'message': {
        'subject': 'Prijava na BastArts Studio Open Class - ${danceClass.fullTeacherNameInline}',
        'html': html,
      },
    };

    if (parentEmail != null) {
      emailMap.addAll({'cc': parentEmail});
    }

    await mailRef.add(emailMap);
  }

  CollectionReference<DanceClass> _danceCollectionRef() => _firestore
      .collection('classes')
      .withConverter(
        fromFirestore: (snapshot, options) => DanceClass.fromJson(snapshot.data()!),
        toFirestore: (value, options) => value.toJson(),
      );

  CollectionReference<Student> _studentsCollectionRef(String id) => _firestore
      .collection('classes/$id/students')
      .withConverter(
        fromFirestore: (snapshot, options) => Student.fromJson(snapshot.data()!),
        toFirestore: (value, options) => value.toJson(),
      );

  DocumentReference<DanceClass> _danceClassRef(String id) => _firestore
      .doc('classes/$id')
      .withConverter(
        fromFirestore: (snapshot, options) => DanceClass.fromJson(snapshot.data()!),
        toFirestore: (value, options) => value.toJson(),
      );

  DocumentReference<Student> _studentRef(String id, String uuid) => _firestore
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
Stream<DanceClass?> danceClassStream(Ref ref, String id) {
  final repository = ref.watch(danceClassRepositoryProvider);
  return repository.watchDanceClass(id);
}

@riverpod
Future<DanceClass?> danceClassFuture(Ref ref, String id) {
  final repository = ref.watch(danceClassRepositoryProvider);
  return repository.fetchDanceClass(id);
}

@riverpod
Stream<int> studentStream(Ref ref, String id) {
  final repository = ref.watch(danceClassRepositoryProvider);
  return repository.watchDanceClassRegistrations(id);
}
