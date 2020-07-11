import 'package:flutter/material.dart';

class MyTextWidget extends StatefulWidget {
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
  _MyTextWidgetState createState() => _MyTextWidgetState();
}

class _MyTextWidgetState extends State<MyTextWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.center,
      controller: widget.controller,
      decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: widget.prefixIcon,
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.grey[400])),
      onChanged: (value) {
        widget.locationCallback(value);
      },
    );
  }
}
