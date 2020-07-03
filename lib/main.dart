import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.orange,
          accentColor: Colors.deepOrangeAccent,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          SignupScreen.id: (context) => SignupScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          SplashScreen.id: (context) => SplashScreen(),
        },
      ),
    );
