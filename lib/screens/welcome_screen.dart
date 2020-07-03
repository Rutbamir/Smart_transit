import 'package:flutter/material.dart';
import 'package:login/screens/login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/bus.jpg'), fit: BoxFit.cover),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 250.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                child: ButtonTheme(
              minWidth: 250,
              height: 50,
              child: RaisedButton(
                elevation: 5.0,
                textColor: Colors.white,
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                child: Text('Login'),
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
            )),
            SizedBox(
              height: 25.0,
            ),
            Container(
                child: ButtonTheme(
              minWidth: 250,
              height: 50,
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.orangeAccent[700],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                child: Text('Sign Up'),
                onPressed: () {
                  Navigator.pushNamed(context, SignupScreen.id);
                },
              ),
            )),
          ],
        ),
      ),
    ));
  }
}
