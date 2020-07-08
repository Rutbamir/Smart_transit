import 'package:flutter/material.dart';
import 'package:login/constants.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        flexibleSpace: Container(decoration: kgradientDecoration),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              //functionality to be added
              print('searching');
            },
          ),
        ],
        backgroundColor: Color.fromRGBO(251, 92, 0, 1),
      ),
    );
  }
}
