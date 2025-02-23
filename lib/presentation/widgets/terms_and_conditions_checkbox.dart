import 'package:bastarts_studio_users/constants/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsCheckbox extends StatelessWidget {
  const TermsAndConditionsCheckbox({super.key, required this.value, required this.onChanged});

  final bool? value;
  final Function(bool? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: 'Strinjam se s ', style: TextTheme.of(context).bodySmall!.copyWith(fontSize: 18)),
            TextSpan(
              text: 'pogoji uporabe',
              style: TextTheme.of(context).bodySmall!.copyWith(
                fontSize: 18,
                color: MyColors.bastRed,
                decoration: TextDecoration.underline,
                decorationColor: MyColors.bastRed,
              ),
              //TODO add url to T&Cs
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
          ],
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      onChanged: onChanged,
    );
  }
}
