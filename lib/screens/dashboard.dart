import 'package:Smart_transit/fetchers/auth.dart';
import 'package:Smart_transit/screens/home_screen.dart';
import 'package:Smart_transit/screens/myBookings.dart';
import 'package:Smart_transit/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_svg/svg.dart';

class Dashboard extends StatefulWidget {
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
                        Positioned(
                          top: 10,
                          left: 10,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            child: IconButton(
                                iconSize: 40,
                                alignment: Alignment.topLeft,
                                icon: SvgPicture.asset(
                                  'assets/menu.svg',
                                  color: Colors.blue[900],
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
            child: FutureBuilder(
                future: FirebaseAuth.instance.currentUser(),
                builder: (context, AsyncSnapshot<FirebaseUser> user) {
                  if (user.hasData) {
                    return ListView(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 30),
                            child: Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                         
                         
                        ],
                      ),
                       SizedBox(height: 15),
                       Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left:20),
                                child: Text(user.data.email,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                           SizedBox(height: 15),
                      Divider(color: Colors.white),
                      ListTile(
                          title: Text('My Bookings',
                              style: TextStyle(color: Colors.white)),
                          leading: Icon(Icons.book, color: Colors.white),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return LoadTicket();
                            }));
                          }),
                      ListTile(
                        title: Text('Logout',
                            style: TextStyle(color: Colors.white)),
                        leading: Icon(Icons.exit_to_app, color: Colors.white),
                        //add logout
                        onTap: () async {
                          await _auth.signOut();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return WelcomeScreen();
                          }));
                        },
                      ),
                    ]);
                  }
                })));
  }
}
