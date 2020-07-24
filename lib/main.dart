import 'package:Smart_transit/animationn.dart';
import 'package:Smart_transit/screens/myBookings.dart';
import 'package:Smart_transit/screens/ticketScreen.dart';
import 'package:Smart_transit/widgets/drawer2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'animationn.dart';
import 'widgets/drawer2.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(
          buttonTheme: ButtonThemeData(buttonColor: Colors.lightBlueAccent),
          primaryColor: Colors.lightBlueAccent,
          accentColor: Colors.blue[600],
          scaffoldBackgroundColor: Colors.white,
          canvasColor: Colors.white,
          textTheme: GoogleFonts.montserratTextTheme(),
          appBarTheme: AppBarTheme(
            elevation: 0,
          ),
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
          WelcomeAnimation.id: (context) => WelcomeAnimation(),
          MyCustomDrawer.id: (context) => MyCustomDrawer(),
          LoadTicket.id: (context) => LoadTicket(),
        },
      ),
    );
