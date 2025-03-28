import 'package:bastarts_studio_users/utils/string_capitalization.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FunctionsRepository {
  FunctionsRepository(this._functions);
  final FirebaseFunctions _functions;

  Future<void> signUpUserToEmailList(String email, String firstName, String lastName) async {
    final result = await _functions.httpsCallable('signUpUser').call({
      'email': email,
      'firstName': firstName.capitalize(),
      'lastName': lastName.capitalize(),
    });

    debugPrint(result.data.toString());
  }
}

final functionsRepositoryProvider = Provider<FunctionsRepository>((ref) {
  return FunctionsRepository(FirebaseFunctions.instance);
});
