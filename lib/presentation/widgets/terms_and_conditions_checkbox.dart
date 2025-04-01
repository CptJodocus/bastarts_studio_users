import 'package:bastarts_studio_users/constants/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionsCheckbox extends StatelessWidget {
  const TermsAndConditionsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.isError = false,
    this.subtitle,
  });

  final bool? value;
  final Function(bool? value)? onChanged;
  final bool isError;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      isError: isError,
      subtitle: subtitle,
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
              mouseCursor: SystemMouseCursors.click,
              recognizer:
                  TapGestureRecognizer()
                    ..onTap = () async {
                      await launchUrl(Uri.parse('https://bastarts.si/pogoji-dolocila-studio/'));
                    },
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
