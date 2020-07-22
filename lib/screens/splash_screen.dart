import 'package:Smart_transit/models/auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _auth = AuthService();
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    if (_auth.getCurrentUser() != null) {
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.id, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, WelcomeScreen.id, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Image.asset('assets/brunch.png'),
    );
  }
}
