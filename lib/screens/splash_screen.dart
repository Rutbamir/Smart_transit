import 'package:Smart_transit/screens/home_screen.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
    //   final FirebaseAuth _auth = FirebaseAuth.instance;

    //   if (_auth.currentUser() == null) {
    //     Navigator.pushNamed(context, WelcomeScreen.id);
    //   } else {
    //     Navigator.pushNamed(context, HomeScreen.id);
    //   }
  }

  startTime() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushNamed(WelcomeScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Image.asset('assets/brunch.png'),
    );
  }
}
