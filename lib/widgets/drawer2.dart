import 'package:flutter/material.dart';
import 'dart:math';

class MyCustomDrawer extends StatefulWidget {
  static String id = 'drawer_screen';
  @override
  _MyCustomDrawerState createState() => _MyCustomDrawerState();
}

class _MyCustomDrawerState extends State<MyCustomDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController _drawerAnimationController;
  Animation _drawerAnimation;

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
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              IconButton(
                                  alignment: Alignment.topLeft,
                                  icon: Icon(Icons.menu,
                                      size: 40.0, color: Colors.blue[600]),
                                  onPressed: () {
                                    if (_drawerAnimationController
                                        .isCompleted) {
                                      _drawerAnimationController.reverse();
                                    } else
                                      _drawerAnimationController.forward();
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ));
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
              customListTile(
                title: 'My Bookings',
                icon: Icons.book,
              ),
              customListTile(
                title: 'Settings',
                icon: Icons.settings,
              ),
              customListTile(
                title: 'Logout',
                icon: Icons.exit_to_app,
              ),
            ],
          ),
        ));
  }
}

class customListTile extends StatelessWidget {
  customListTile({this.title, this.icon});
  final title;
  final icon;
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
    );
  }
}
