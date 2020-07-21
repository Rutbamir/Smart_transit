import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../Animation/FadeAnimation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  bool _autoValidate = false;
  final _auth = FirebaseAuth.instance;

  String email;
  String password;

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
              key: _loginKey,
              autovalidate: _autoValidate,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/bus2.jpg'),
                          fit: BoxFit.contain),
                    ),
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
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]))),
                                  child: TextFormField(
                                    validator: (value) => value.isEmpty
                                        ? 'Email can\'t be empty'
                                        : null,
                                    onSaved: (value) {
                                      email = value.trim();
                                      print(email);
                                    },
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Enter Your Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    onSaved: (value) {
                                      print(value);
                                      password = value.trim();
                                      print(password);
                                    },
                                    validator: (value) =>
                                        value.isEmpty ? "Required" : null,
                                    textAlign: TextAlign.center,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FadeAnimation(
                          2,
                          Container(
                            width: 400,
                            height: 50,
                            child: RaisedButton(
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0)),
                              child: Text('Login'),
                              onPressed: () {
                                _validateLoginInput();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _validateLoginInput() async {
    final FormState form = _loginKey.currentState;
    if (_loginKey.currentState.validate()) {
      form.save();

      try {
        final user = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        Navigator.pushNamed(context, HomeScreen.id);
      } catch (error) {}
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
