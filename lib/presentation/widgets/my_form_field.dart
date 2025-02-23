import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyFormField extends StatelessWidget {
  const MyFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.textInputAction,
    this.keyboardType,
    this.autoFillHints,
    this.maxLength,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onChanged,
  });

  final TextEditingController controller;
  final String labelText;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final Iterable<String>? autoFillHints;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
        filled: true,
        fillColor: Colors.white,
        floatingLabelStyle: TextStyle(color: Colors.black54),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelText: labelText,
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        counterText: '',
      ),
      maxLines: 1,
      maxLength: maxLength,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      autofillHints: autoFillHints,
      inputFormatters: inputFormatters,
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
    );
  }
}
