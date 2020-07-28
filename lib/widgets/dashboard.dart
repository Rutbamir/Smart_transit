import 'package:Smart_transit/models/auth.dart';
import 'package:Smart_transit/screens/home_screen.dart';
import 'package:Smart_transit/screens/myBookings.dart';
import 'package:Smart_transit/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_svg/svg.dart';

class Dashboard extends StatefulWidget {
  static String id = 'dashboard';
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  AnimationController _drawerAnimationController;
  Animation _drawerAnimation;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    initDrawerAnimation();
  }

  initDrawerAnimation() {
    _drawerAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _drawerAnimation =
        Tween(begin: 0.0, end: 200.0).animate(_drawerAnimationController);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          blueDrawer(),
          AnimatedBuilder(
              animation: _drawerAnimation,
              builder: (context, widget) {
                return Transform.translate(
                  offset: Offset(_drawerAnimation.value, 0),
                  child: Transform.scale(
                    scale: max((200.0 - _drawerAnimation.value) / 200, 0.75),
                    child: Stack(
                      children: [
                        HomeScreen(),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: IconButton(
                                iconSize: 30,
                                alignment: Alignment.topLeft,
                                icon: SvgPicture.asset(
                                  'assets/menu.svg',
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  if (_drawerAnimationController.isCompleted) {
                                    _drawerAnimationController.reverse();
                                  } else
                                    _drawerAnimationController.forward();
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
        ],
      )),
    );
  }

  blueDrawer() {
    return Scaffold(
        backgroundColor: Colors.blue[600],
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              CustomListTile(
                  title: 'My Bookings',
                  icon: Icons.book,
                  onTap: () {
                    Navigator.pushNamed(context, LoadTicket.id);
                  }),
              CustomListTile(
                title: 'Settings',
                icon: Icons.settings,
              ),
              CustomListTile(
                title: 'Logout',
                icon: Icons.exit_to_app,
                //add logout
                onTap: () async {
                  await _auth.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, WelcomeScreen.id, (route) => false);
                },
              ),
            ],
          ),
        ));
  }
}

class CustomListTile extends StatelessWidget {
  CustomListTile({this.title, this.icon, this.onTap});
  final title;
  final icon;
  final onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,
          style: TextStyle(
            color: Colors.white,
          )),
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      onTap: onTap,
    );
  }
}
