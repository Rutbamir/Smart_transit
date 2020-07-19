import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:core';

const kGoogleApiKey = 'AIzaSyAf76N_-Fku1xYtqMLju9hrTf0Xb0xRjEc';
const chars = "0123456789";

const kgradientDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: <Color>[Colors.deepOrangeAccent, Colors.orangeAccent],
  ),
);

//generates random numbers
String krandomNumber() {
  int strlen = 5;
  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  for (var i = 0; i < strlen; i++) {
    result += chars[rnd.nextInt(chars.length)];
  }

  return result;
}
