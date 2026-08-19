import 'dart:async';

import 'package:bastarts_studio_users/constants/my_input_decoration.dart';
import 'package:bastarts_studio_users/data/extra_class_provider.dart';
import 'package:bastarts_studio_users/domain/dance_class.dart';
import 'package:bastarts_studio_users/presentation/functions_repository.dart';
import 'package:bastarts_studio_users/presentation/sign_up_screen_controller.dart';
import 'package:bastarts_studio_users/presentation/widgets/confirmation_screen.dart';
import 'package:bastarts_studio_users/presentation/widgets/terms_and_conditions_checkbox.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpFields extends ConsumerStatefulWidget {
  const SignUpFields({
    super.key,
    required this.danceClass,
    required this.nameController,
    required this.surnameController,
    required this.emailController,
    required this.birthDayController,
    required this.birthYearController,
    required this.parentNameController,
    required this.parentSurnameController,
    required this.parentEmailController,
    required this.birthMonthController,
  });

  final DanceClass danceClass;
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController emailController;
  final TextEditingController birthDayController;
  final TextEditingController birthMonthController;
  final TextEditingController birthYearController;
  final TextEditingController parentNameController;
  final TextEditingController parentSurnameController;
  final TextEditingController parentEmailController;

  @override
  ConsumerState<SignUpFields> createState() => _SignUpFieldsState();
}

class _SignUpFieldsState extends ConsumerState<SignUpFields> {
  void _checkIfUserIsOfAge() {
    final day = int.tryParse(widget.birthDayController.value.text);
    final month = int.tryParse(widget.birthMonthController.text);
    final year = int.tryParse(widget.birthYearController.value.text);
    if (day is int && month is int && year is int) {
      setState(() {
        ofAge = DateTime(year + 18, month, day).isBefore(DateTime.now());
      });
      if (termsAgree == true) {
        //If user already agreed to terms, and is little bebe, set to false instead
        termsAgree = ofAge;
      }
    }
  }

  void _termsCheckboxOnTap(bool? value) {
    if (value != null) {
      setState(() {
        termsAgree = value;
        _validateTermsCheckbox();
      });
    }
  }

  bool _validateTermsCheckbox() {
    if (!termsAgree) {
      setState(() {
        termsError = true;
        termsErrorMessage = Text(
          _compulsory,
          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.error),
        );
      });
      return false;
    } else {
      setState(() {
        termsError = false;
        termsErrorMessage = null;
      });
      return true;
    }
  }

  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return _compulsory;
    } else {
      return null;
    }
  }

  String? _validateEmail(String? value) {
    final stringIfEmpty = _validateNotEmpty(value);
    if (stringIfEmpty != null) {
      return stringIfEmpty;
    } else {
      final isValidEmail = EmailValidator.validate(value!);
      if (!isValidEmail) {
        return 'Prosim vnesite veljaven e-poštni naslov';
      }
    }

    return null;
  }

  String? _nullIfEmptyField(String string) {
    if (string == '') {
      return null;
    } else {
      return string;
    }
  }

  String? _validateBirthDay(String? value) {
    final stringIfEmpty = _validateNotEmpty(value);
    if (stringIfEmpty != null) {
      return stringIfEmpty;
    } else {
      final day = int.tryParse(value!);
      if (day == null) return 'Prosimo vnesite samo številke';
      if (day > 31) return 'Prosimo vnesite veljaven dan';
    }

    return null;
  }

  String? _validateBirthMonth(String? value) {
    final stringIfEmpty = _validateNotEmpty(value);
    if (stringIfEmpty != null) {
      return stringIfEmpty;
    } else {
      final month = int.tryParse(value!);
      if (month == null) return 'Prosimo vnesite samo številke';
      if (month > 12) return 'Prosimo vnesite veljaven mesec';
    }

    return null;
  }

  String? _validateBirthYear(String? value) {
    final stringIfEmpty = _validateNotEmpty(value);
    if (stringIfEmpty != null) {
      return stringIfEmpty;
    } else {
      final year = int.tryParse(value!);
      if (year == null) return 'Prosimo vnesite samo številke';
      if (DateTime(year + 3).isAfter(DateTime.now()) || DateTime(year + 100).isBefore(DateTime.now())) {
        return 'Prosimo vnesite veljavno leto';
      }
    }

    return null;
  }

  final double spacing = 12;
  static final String _compulsory = 'To polje je obvezno';

  Timer? _yearDebounceTimer;

  bool ofAge = true;

  bool? mailingListSubscribe = false;
  bool termsAgree = false;
  bool termsError = false;
  Widget? termsErrorMessage;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _yearDebounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: spacing,
          children: [
            Row(
              spacing: spacing,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.nameController,
                    validator: (value) => _validateNotEmpty(value),
                    decoration: MyInputDecoration.decoration(labelText: 'Ime'),
                    keyboardType: TextInputType.name,
                    autofillHints: [AutofillHints.givenName],
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: widget.surnameController,
                    decoration: MyInputDecoration.decoration(labelText: 'Priimek'),
                    validator: (value) => _validateNotEmpty(value),
                    keyboardType: TextInputType.name,
                    autofillHints: [AutofillHints.familyName],
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: widget.emailController,
              decoration: MyInputDecoration.decoration(labelText: 'E-pošta'),
              validator: (value) => _validateEmail(value),
              textInputAction: TextInputAction.next,
              autofillHints: [AutofillHints.email],
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 8),
            Text('Datum rojstva', style: TextTheme.of(context).bodySmall!.copyWith(fontSize: 18)),
            Row(
              spacing: spacing,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: TextFormField(
                    controller: widget.birthDayController,
                    decoration: MyInputDecoration.decoration(
                      labelText: 'Dan',
                      hintText: '31',
                      floatingLabelBehaviour: .always,
                    ),
                    validator: (value) => _validateBirthDay(value),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    autofillHints: [AutofillHints.birthdayDay],
                    maxLength: 2,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => _checkIfUserIsOfAge(),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: widget.birthMonthController,
                    decoration: MyInputDecoration.decoration(
                      labelText: 'Mesec',
                      hintText: '12',
                      floatingLabelBehaviour: .always,
                    ),
                    validator: (value) => _validateBirthMonth(value),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    autofillHints: [AutofillHints.birthdayMonth],
                    maxLength: 2,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => _checkIfUserIsOfAge(),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: widget.birthYearController,
                    decoration: MyInputDecoration.decoration(
                      labelText: 'Leto',
                      hintText: '2000',
                      floatingLabelBehaviour: .always,
                    ),
                    validator: (value) => _validateBirthYear(value),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    autofillHints: [AutofillHints.birthdayYear],
                    maxLength: 4,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    //Hopefully this is cheap enough that I don't care about running it on every change
                    onChanged: (_) {
                      if (_yearDebounceTimer?.isActive ?? false) _yearDebounceTimer?.cancel();
                      _yearDebounceTimer = Timer(
                        const Duration(milliseconds: 500),
                        () => _checkIfUserIsOfAge(),
                      );
                    },
                  ),
                ),
              ],
            ),
            CheckboxListTile(
              value: mailingListSubscribe,
              onChanged: (value) {
                setState(() {
                  mailingListSubscribe = value;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Želim si prejemati tedenska obvestila o novih klasih',
                style: TextTheme.of(context).bodySmall!.copyWith(fontSize: 18),
              ),
            ),
            ofAge
                ? TermsAndConditionsCheckbox(
                    value: termsAgree,
                    onChanged: (value) => _termsCheckboxOnTap(value),
                    isError: termsError,
                    subtitle: termsErrorMessage,
                  )
                : Card(
                    margin: EdgeInsets.zero,
                    color: Colors.white,
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: spacing,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'izjava zakonitega zastopnika',
                                style: TextTheme.of(context).bodySmall!.copyWith(fontSize: 18),
                              ),
                              Text(
                                '(Izpolni starš ali zakoniti zastopnik)',
                                style: TextTheme.of(context).bodySmall!.copyWith(fontSize: 10, color: Colors.black54),
                              ),
                            ],
                          ),
                          Row(
                            spacing: spacing,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: widget.parentNameController,
                                  decoration: MyInputDecoration.decoration(labelText: 'Ime'),
                                  validator: (value) => _validateNotEmpty(value),
                                  keyboardType: TextInputType.name,
                                  autofillHints: [AutofillHints.givenName],
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: widget.parentSurnameController,
                                  decoration: MyInputDecoration.decoration(labelText: 'Priimek'),
                                  validator: (value) => _validateNotEmpty(value),

                                  keyboardType: TextInputType.name,
                                  autofillHints: [AutofillHints.familyName],
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: widget.parentEmailController,
                            decoration: MyInputDecoration.decoration(labelText: 'E-pošta'),
                            textInputAction: TextInputAction.next,
                            autofillHints: [AutofillHints.email],
                            validator: (value) => _validateEmail(value),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          TermsAndConditionsCheckbox(
                            value: termsAgree,
                            onChanged: (value) => _termsCheckboxOnTap(value),
                            isError: termsError,
                            subtitle: termsErrorMessage,
                          ),
                        ],
                      ),
                    ),
                  ).animate(target: ofAge == true ? 0 : 1).scaleY(alignment: Alignment.topCenter).fadeIn(),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() && _validateTermsCheckbox()) {
                  final navigator = Navigator.of(context);
                  final success = await ref
                      .read(signUpScreenControllerProvider.notifier)
                      .register(
                        danceClass: widget.danceClass,
                        firstName: widget.nameController.text,
                        lastName: widget.surnameController.text,
                        email: widget.emailController.text,
                        parentName: _nullIfEmptyField(widget.parentNameController.text),
                        parentSurname: _nullIfEmptyField(widget.parentSurnameController.text),
                        parentEmail: _nullIfEmptyField(widget.parentEmailController.text),
                      );

                  final extraClasses = ref.watch(extraClassProvider);

                  for (var danceClass in extraClasses) {
                    await ref
                        .read(signUpScreenControllerProvider.notifier)
                        .register(
                          danceClass: danceClass,
                          firstName: widget.nameController.text,
                          lastName: widget.surnameController.text,
                          email: widget.emailController.text,
                          parentName: _nullIfEmptyField(widget.parentNameController.text),
                          parentSurname: _nullIfEmptyField(widget.parentSurnameController.text),
                          parentEmail: _nullIfEmptyField(widget.parentEmailController.text),
                        );
                  }

                  if (mailingListSubscribe == true) {
                    ref
                        .read(functionsRepositoryProvider)
                        .signUpUserToEmailList(
                          widget.emailController.text,
                          widget.nameController.text,
                          widget.surnameController.text,
                        );
                  }
                  if (success) {
                    navigator.pushReplacement(MaterialPageRoute(builder: (context) => ConfirmationScreen()));
                  }
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.black),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              child: Text('Prijavi se'),
            ),
          ],
        ),
      ),
    );
  }
}
