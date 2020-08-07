import 'package:Smart_transit/models/auth.dart';
import 'package:Smart_transit/models/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Smart_transit/widgets/dashboard.dart';
import '../Animation/FadeAnimation.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final AuthService _auth = AuthService();
  bool _autoValidate = false;
  bool loading = false;

  String email;
  String password;
  String errorMessage;

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: loading
          ? Loading()
          : Scaffold(
              key: _scaffoldKey,
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
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                errorMessage != null ? errorMessage : '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                    color: Colors.red),
                              ),
                            ),
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
                                        color:
                                            Color.fromRGBO(143, 148, 251, .2),
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
                                          textAlign: TextAlign.center,
                                          validator: (value) => value.isEmpty
                                              ? 'Email can\'t be empty'
                                              : null,
                                          onSaved: (value) {
                                            email = value.trim();
                                            print(email);
                                          },
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
                                          textAlign: TextAlign.center,
                                          obscureText: true,
                                          onSaved: (value) {
                                            password = value.trim();
                                            print(password);
                                          },
                                          validator: (value) => value.length < 6
                                              ? 'Enter a password 6+ chars long'
                                              : null,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Password",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400])),
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
                                        borderRadius:
                                            BorderRadius.circular(18.0)),
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
    form.validate();
    setState(() {
      loading = true;
    });

    form.save();

    try {
      AuthResult result =
          await _auth.signInWithEmailAndPassword(email, password);
      setState(() {
        loading = false;
      });
      result != null
          ? Navigator.pushNamedAndRemoveUntil(
              context, Dashboard.id, (route) => false)
          : null;
    } catch (e) {
      setState(() {
        loading = false;
      });
      setState(() {
        errorMessage = 'Something went wrong! \n check email and password';
      });
      print(e);
    }
  }
}
