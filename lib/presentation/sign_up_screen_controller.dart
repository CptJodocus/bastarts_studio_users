import 'package:bastarts_studio_users/data/dance_class_repository.dart';
import 'package:bastarts_studio_users/domain/dance_class.dart';
import 'package:bastarts_studio_users/utils/string_capitalization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_screen_controller.g.dart';

@riverpod
class SignUpScreenController extends _$SignUpScreenController {
  @override
  FutureOr<void> build() {}

  Future<bool> register({
    required DanceClass danceClass,
    required String firstName,
    required String lastName,
    required String email,
    String? parentName,
    String? parentSurname,
    String? parentEmail,
  }) async {
    final repository = ref.watch(danceClassRepositoryProvider);

    state = AsyncLoading();

    final capitalizedName = firstName.capitalize();
    final capitalizedSurname = lastName.capitalize();

    try {
      final alreadySignedUp = await repository.alreadyRegistered(
        danceClass.classId,
        email,
      );
      if (alreadySignedUp) {
        state = AsyncError(
          'Uporabnik s tem e-poštnim naslovom je že prijavljen',
          StackTrace.current,
        );
        return false;
      } else {
        await repository.register(
          danceClassId: danceClass.classId,
          firstName: capitalizedName,
          lastName: capitalizedSurname,
          email: email,
          parentEmail: parentEmail,
          parentName: parentName,
          parentSurname: parentSurname,
        );

        final packageExtraString = danceClass.connectedClassId != null
            ? '\nZa obisk obeh tečajev v paketu je prispevek skupaj ${danceClass.packagePrice}€.\n\n'
            : null;

        if (danceClass.requestPrepayment) {
          await repository.sendPaymentRequestEmail(
            danceClass: danceClass,
            firstName: firstName,
            email: email,
            parentEmail: parentEmail,
            extra: packageExtraString,
          );
          state = AsyncData(null);
          return true;
        } else {
          await repository.sendRegistrationEmail(
            danceClass: danceClass,
            firstName: capitalizedName,
            email: email,
            parentEmail: parentEmail,
            extra: packageExtraString,
          );
          state = AsyncData(null);
          return true;
        }
      }
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }
}
