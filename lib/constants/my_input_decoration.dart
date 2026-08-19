import 'package:flutter/material.dart';

class MyInputDecoration {
  static InputDecoration decoration({String? labelText}) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
      filled: true,
      fillColor: Colors.white,
      floatingLabelStyle: TextStyle(color: Colors.black54),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: labelText,
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      counterText: '',
      errorMaxLines: 3,
      errorStyle: TextStyle(fontSize: 12),
    );
  }
}
