import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white,
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        body: Container(
            child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Let's Get Started..",
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ))),
            Container(
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/app.jpg'), fit: BoxFit.contain),
              ),
            ),
            Container(
              width: 250,
              height: 50,
              child: RaisedButton(
                elevation: 5.0,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Text('Login'),
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Container(
              width: 250,
              height: 50,
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Text('Sign Up'),
                onPressed: () {
                  Navigator.pushNamed(context, SignupScreen.id);
                },
              ),
            ),
          ],
        )),
      ),
    );
  }
}
