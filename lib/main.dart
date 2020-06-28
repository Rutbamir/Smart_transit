import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orange,
        accentColor: Colors.deepOrangeAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    ));
