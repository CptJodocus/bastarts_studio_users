import 'package:bastarts_studio_users/presentation/widgets/my_form_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SignUpFields extends StatelessWidget {
  const SignUpFields({
    super.key,
    required this.birthDayController,
    required this.birthYearController,
    required this.nameController,
    required this.surnameController,
    required this.emailController,
  });

  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController emailController;
  final TextEditingController birthDayController;
  final TextEditingController birthYearController;

  @override
  Widget build(BuildContext context) {
    final List<String> monthNames = List.generate(
      12,
      (index) => DateFormat.MMMM('sl').format(DateTime(2000, index + 1)),
    );

    final double spacing = 12;

    //TODO this needs a bunch of validation to make sure you get actual values, and error messages where needed
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: spacing,
      children: [
        Row(
          spacing: spacing,
          children: [
            Expanded(
              child: MyFormField(
                controller: nameController,
                labelText: 'Ime',
                keyboardType: TextInputType.name,
                autoFillHints: [AutofillHints.givenName],
                textInputAction: TextInputAction.next,
              ),
            ),
            Expanded(
              child: MyFormField(
                controller: surnameController,
                labelText: 'Priimek',
                keyboardType: TextInputType.name,
                autoFillHints: [AutofillHints.familyName],
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
        MyFormField(
          controller: emailController,
          labelText: 'E-pošta',
          textInputAction: TextInputAction.next,
          autoFillHints: [AutofillHints.email],
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 8),
        Text('Datum rojstva', style: TextTheme.of(context).bodySmall!.copyWith(fontSize: 18)),
        Row(
          spacing: spacing,
          children: [
            Expanded(
              child: MyFormField(
                controller: birthDayController,
                labelText: 'Dan',
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.datetime,
                autoFillHints: [AutofillHints.birthdayDay],
              ),
            ),
            Expanded(
              child: DropdownButtonFormField(
                items: List.generate(12, (index) {
                  return DropdownMenuItem(value: monthNames[index], child: Text(monthNames[index]));
                }),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  filled: true,
                  fillColor: Colors.white,
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: 'Mesec',
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                ),
                onChanged: (value) {},
              ),
            ),
            Expanded(
              child: MyFormField(
                controller: birthYearController,
                labelText: 'Leto',
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.datetime,
                autoFillHints: [AutofillHints.birthdayYear],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
