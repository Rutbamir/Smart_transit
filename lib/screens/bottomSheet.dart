import 'package:flutter/material.dart';

class AddBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Color(0xff757575),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            )),
        child: Text('hello'),
      ),
    );
  }
}
