import 'package:Smart_transit/UiHelper.dart';
import 'package:Smart_transit/fetchers/auth.dart';
import 'package:Smart_transit/screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Animation/FadeAnimation.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  UiHelper _uiHelper = UiHelper();

  AuthService _auth = AuthService();
  String errorMessage;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Container(
                child: Form(
                  key: _signUpKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/bus2.jpg'),
                                fit: BoxFit.contain)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              errorMessage != null ? errorMessage : '',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                  color: Colors.red),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Column(
                          children: <Widget>[
                            FadeAnimation(
                                1.8,
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                143, 148, 251, .2),
                                            blurRadius: 20.0,
                                            offset: Offset(0, 10))
                                      ]),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey[100]))),
                                        child: TextFormField(
                                          controller: emailController,
                                          textAlign: TextAlign.center,
                                          validator: (value) => value.isEmpty
                                              ? 'Email can\'t be empty'
                                              : null,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Enter Your Email",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400])),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          obscureText: true,
                                          controller: passwordController,
                                          validator: (value) => value.length < 6
                                              ? 'Enter a password 6+ chars long'
                                              : null,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Password",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400])),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          obscureText: true,
                                          controller: confirmPasswordController,
                                          validator: (value) =>
                                              value != passwordController.text
                                                  ? 'The passwords don\'t match'
                                                  : null,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Confirm Password",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400])),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            SizedBox(
                              height: 50,
                            ),
                            FadeAnimation(
                              2,
                              Container(
                                width: 400,
                                height: 50,
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  color: Colors.blue[600],
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0)),
                                  child: Text('Sign Up'),
                                  onPressed: () async {
                                    await _validatesignUpInput();
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  void _validatesignUpInput() async {
    final FormState form = _signUpKey.currentState;
    if (form.validate()) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
      try {
        FirebaseUser result = await _auth.registerWithEmailAndPassword(
            emailController.text, passwordController.text);

        result != null
            ? Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Dashboard();
              }))
            : null;
      } catch (e) {
        print(e);
        Navigator.pop(context);
        setState(() {
        errorMessage = 'Check email and password';
      });
      }
    } else {
      setState(() {
        errorMessage = 'Check email and password';
      });
    }
  }
}
