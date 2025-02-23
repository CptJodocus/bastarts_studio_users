import 'package:flutter/material.dart';

class MyFormField extends StatelessWidget {
  const MyFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.textInputAction,
    this.keyboardType,
    this.autoFillHints,
  });

  final TextEditingController controller;
  final String labelText;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final Iterable<String>? autoFillHints;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        filled: true,
        fillColor: Colors.white,
        floatingLabelStyle: TextStyle(color: Colors.black),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelText: labelText,
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
      maxLines: 1,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      autofillHints: autoFillHints,
    );
  }
}
