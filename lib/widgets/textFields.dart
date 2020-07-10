import 'package:flutter/material.dart';

class MyTextWidget extends StatelessWidget {
  MyTextWidget(
      {this.hint,
      this.prefixIcon,
      this.controller,
      this.initialValue,
      this.locationCallback});

  final String hint;
  final Widget prefixIcon;
  final TextEditingController controller;
  final String initialValue;
  final Function(String) locationCallback;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.center,
      initialValue: initialValue,
      decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: prefixIcon,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400])),
      onChanged: (value) {
        locationCallback(value);
      },
    );
  }
}
