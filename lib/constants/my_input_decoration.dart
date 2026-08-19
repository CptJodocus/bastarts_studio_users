import 'package:flutter/material.dart';

class MyInputDecoration {
  static InputDecoration decoration({
    String? labelText,
    String? hintText,
    FloatingLabelBehavior floatingLabelBehaviour = .auto,
  }) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
      filled: true,
      fillColor: Colors.white,
      floatingLabelStyle: TextStyle(color: Colors.black54),
      floatingLabelBehavior: floatingLabelBehaviour,
      labelText: labelText,
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      counterText: '',
      errorMaxLines: 3,
      errorStyle: TextStyle(fontSize: 12),
    );
  }
}
