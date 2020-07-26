import 'package:Smart_transit/widgets/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..forward();
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
    startTime();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  startTime() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    if (await _auth.currentUser() != null) {
      Navigator.pushNamedAndRemoveUntil(
          context, MainPage.id, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, WelcomeScreen.id, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _offsetAnimation,
              child: Image.asset(
                'assets/logo.png',
                height: 300,
                width: 300,
                fit: BoxFit.contain,
              ),
            ),
            Center(
              child: Text(
                'omnibus',
                style: TextStyle(
                  fontSize: 45.0,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
