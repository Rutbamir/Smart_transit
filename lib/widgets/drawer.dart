import 'package:Smart_transit/models/auth.dart';
import 'package:Smart_transit/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:Smart_transit/screens/myBookings.dart';

class MyDrawer extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
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
              Navigator.pushNamed(context, LoadTicket.id);
            }),
        ListTile(
          title: Text("Settings"),
          leading: Icon(Icons.settings),
        ),
        ListTile(
          title: Text("Log Out"),
          leading: Icon(Icons.exit_to_app),
          //add logout
          onTap: () async {
            await _auth.signOut();
            Navigator.pushNamedAndRemoveUntil(
                context, WelcomeScreen.id, (route) => false);
          },
        ),
      ],
    ));
  }
}
