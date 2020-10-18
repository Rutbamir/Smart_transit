import 'package:Smart_transit/screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
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
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print('Animation completed');
        startTime();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  startTime() {
    var _duration = Duration(milliseconds: 1);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    if (await FirebaseAuth.instance.currentUser() != null) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Dashboard();
      }));
    } else {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return WelcomeScreen();
      }));
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
