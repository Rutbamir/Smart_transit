import 'package:Smart_transit/screens/ticketScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(
          // buttonColor: Colors.orange,
          primaryColor: Color(0xff0779e4),
          accentColor: Color(0xffeff3c6),
          fontFamily: 'Product Sans',
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          SignupScreen.id: (context) => SignupScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          SplashScreen.id: (context) => SplashScreen(),
          TicketScreen.id: (context) => TicketScreen(),
        },
      ),
    );
