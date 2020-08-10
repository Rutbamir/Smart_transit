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
  
}
