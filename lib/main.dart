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
          buttonTheme: ButtonThemeData(buttonColor: Colors.lightBlueAccent),
          primaryColor: Colors.lightBlueAccent,
          accentColor: Colors.blue[600],
          fontFamily: 'Product Sans',
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: HomeScreen.id,
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
