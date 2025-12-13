import 'package:bastarts_studio_users/data/extra_class_provider.dart';
import 'package:bastarts_studio_users/domain/dance_class.dart';
import 'package:bastarts_studio_users/presentation/functions_repository.dart';
import 'package:bastarts_studio_users/presentation/sign_up_screen_controller.dart';
import 'package:bastarts_studio_users/presentation/widgets/confirmation_screen.dart';
import 'package:bastarts_studio_users/presentation/widgets/my_form_field.dart';
import 'package:bastarts_studio_users/presentation/widgets/terms_and_conditions_checkbox.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
  });

  final DanceClass danceClass;
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController emailController;
  final TextEditingController birthDayController;
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
    final month = birthMonth;
    final year = int.tryParse(widget.birthYearController.value.text);
    if (day is int && month > 0 && year is int) {
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

  final List<String> monthNames = List.generate(12, (index) => DateFormat.MMMM('sl').format(DateTime(2000, index + 1)));

  final double spacing = 12;
  static final String _compulsory = 'To polje je obvezno';

  int birthMonth = 0;
  bool ofAge = true;

  bool? mailingListSubscribe = false;
  bool termsAgree = false;
  bool termsError = false;
  Widget? termsErrorMessage;

  final _formKey = GlobalKey<FormState>();
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
                  child: MyFormField(
                    controller: widget.nameController,
                    labelText: 'Ime',
                    validator: (value) => _validateNotEmpty(value),
                    keyboardType: TextInputType.name,
                    autoFillHints: [AutofillHints.givenName],
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Expanded(
                  child: MyFormField(
                    controller: widget.surnameController,
                    labelText: 'Priimek',
                    validator: (value) => _validateNotEmpty(value),

                    keyboardType: TextInputType.name,
                    autoFillHints: [AutofillHints.familyName],
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
            MyFormField(
              controller: widget.emailController,
              labelText: 'E-pošta',
              validator: (value) => _validateEmail(value),
              textInputAction: TextInputAction.next,
              autoFillHints: [AutofillHints.email],
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 8),
            Text('Datum rojstva', style: TextTheme.of(context).bodySmall!.copyWith(fontSize: 18)),
            Row(
              spacing: spacing,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: MyFormField(
                    controller: widget.birthDayController,
                    labelText: 'Dan',
                    validator: (value) => _validateNotEmpty(value),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    autoFillHints: [AutofillHints.birthdayDay],
                    maxLength: 2,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => _checkIfUserIsOfAge(),
                  ),
                ),
                Expanded(
                  //TODO I wish I could've figured this out for better UX, but fuck it, this is how Google does it too
                  // child: DropdownMenu(
                  //   dropdownMenuEntries: List.generate(12, (index) {
                  //     return DropdownMenuEntry(
                  //       value: index + 1,
                  //       label: monthNames[index],
                  //       labelWidget: Text(
                  //         monthNames[index],
                  //         style: TextTheme.of(context).bodySmall!.copyWith(fontSize: 16),
                  //       ),
                  //     );
                  //   }),
                  //   label: Text('Mesec', maxLines: 1),
                  //   enableSearch: true,
                  //   width: 1000,
                  //   enableFilter: true,
                  //   menuStyle: MenuStyle(
                  //     backgroundColor: WidgetStatePropertyAll(Colors.white),
                  //     maximumSize: WidgetStatePropertyAll(Size(200, 800)),
                  //     minimumSize: WidgetStatePropertyAll(Size(0, 300)),
                  //   ),
                  //   inputDecorationTheme: InputDecorationTheme(
                  //     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  //     filled: true,
                  //     fillColor: Colors.white,
                  //     floatingLabelStyle: TextStyle(color: Colors.black),
                  //     floatingLabelBehavior: FloatingLabelBehavior.auto,
                  //     border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  //   ),
                  // ),
                  child: DropdownButtonFormField(
                    items: List.generate(12, (index) {
                      return DropdownMenuItem(value: index + 1, child: Text(monthNames[index]));
                    }),
                    isExpanded: true,

                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
                      filled: true,
                      fillColor: Colors.white,
                      floatingLabelStyle: TextStyle(color: Colors.black54),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelText: 'Mesec',
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      errorMaxLines: 3,
                      errorStyle: TextStyle(fontSize: 12),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return _compulsory;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value != null) birthMonth = value;
                      _checkIfUserIsOfAge();
                    },
                  ),
                ),
                Expanded(
                  child: Focus(
                    onFocusChange: (value) {
                      _checkIfUserIsOfAge();
                    },
                    child: MyFormField(
                      controller: widget.birthYearController,
                      labelText: 'Leto',
                      validator: (value) => _validateNotEmpty(value),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      autoFillHints: [AutofillHints.birthdayYear],
                      maxLength: 4,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onEditingComplete: () {
                        _checkIfUserIsOfAge();
                      },
                    ),
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
                              child: MyFormField(
                                controller: widget.parentNameController,
                                labelText: 'Ime',
                                validator: (value) => _validateNotEmpty(value),
                                keyboardType: TextInputType.name,
                                autoFillHints: [AutofillHints.givenName],
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            Expanded(
                              child: MyFormField(
                                controller: widget.parentSurnameController,
                                labelText: 'Priimek',
                                validator: (value) => _validateNotEmpty(value),

                                keyboardType: TextInputType.name,
                                autoFillHints: [AutofillHints.familyName],
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ],
                        ),
                        MyFormField(
                          controller: widget.parentEmailController,
                          labelText: 'E-pošta',
                          textInputAction: TextInputAction.next,
                          autoFillHints: [AutofillHints.email],
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
