import 'package:flutter/material.dart';
import 'dart:async';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> parent of eeb14f3... auth fix
    // FirebaseAuth.instance.currentUser().then((currentUser) => {
    //   if (currentUser == null) {
    //     Navigator.PushEvent
    //   }
    // },
<<<<<<< HEAD
>>>>>>> parent of eeb14f3... auth fix
=======
>>>>>>> parent of eeb14f3... auth fix
    startTime();
  }

  startTime() async {
    var _duration = Duration(seconds: 2);
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
