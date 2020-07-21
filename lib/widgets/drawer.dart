import 'package:Smart_transit/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({this.authkey});
  final authkey;

  Widget build(BuildContext context) {
    FirebaseAuth _auth = authkey;
    return Drawer(
        child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          accountName: Text('Someone'),
          accountEmail: Text('someone@gmail.com'),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image.asset('assets/user.jpg'),
            ),
          ),
        ),
        Divider(
          color: Colors.orange[900],
          indent: 30.0,
          endIndent: 30.0,
        ),
        ListTile(
            title: Text("My Bookings"),
            leading: Icon(Icons.book),
            onTap: () {
              print('functionality to be added');
            }),
        ListTile(
          title: Text("Settings"),
          leading: Icon(Icons.settings),
        ),
        ListTile(
          title: Text("Log Out"),
          leading: Icon(Icons.exit_to_app),
          onTap: () {
            _auth.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
                WelcomeScreen.id, (Route<dynamic> route) => false);
          },
        ),
      ],
    ));
  }
}
