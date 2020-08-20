import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UiHelper {
  Widget getLoading() {
    return Container(
      color: Colors.white,
      child: Center(
          child: SpinKitChasingDots(
        color: Colors.lightBlueAccent,
        size: 50.0,
      )),
    );
  }

  Widget getTextField(
      {@required Function onTap,
      @required TextEditingController controller,
      @required Icon icon,
      @required String hint,
      @required Function validator}) {
    return TextFormField(
      validator: validator,
      onTap: onTap,
      textAlign: TextAlign.center,
      controller: controller,
      decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: icon,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400])),
    );
  }
}
