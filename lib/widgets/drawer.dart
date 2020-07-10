import 'package:flutter/material.dart';
import 'package:login/constants.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: kgradientDecoration,
          accountName: Text('Someone'),
          accountEmail: Text('someone@gmail.com'),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image.asset('assets/user.jpg'),
            ),
          ),
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
        ),
      ],
    ));
  }
}
