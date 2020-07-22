import 'package:Smart_transit/screens/home_screen.dart';
import 'package:Smart_transit/screens/login_screen.dart';
import 'package:Smart_transit/screens/ticketScreen.dart';
import 'package:Smart_transit/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  Future<Object> navigation;
  Widget _child;
  @override
  Widget build(BuildContext context) {
    return FluidNavBar(
      icons: [
        FluidNavBarIcon(
          iconPath: 'assets/home.svg',
          backgroundColor: Colors.white,
          extras: {
            'label': 'home',
          },
        ),
        FluidNavBarIcon(
          iconPath: 'assets/pin.svg',
          backgroundColor: Colors.white,
          extras: {
            'label': 'map',
          },
        ),
        FluidNavBarIcon(
          iconPath: 'assets/bus.svg',
          backgroundColor: Colors.white,
          extras: {
            'label': 'booking',
          },
        ),
        FluidNavBarIcon(
          iconPath: 'assets/profile.svg',
          backgroundColor: Colors.white,
          extras: {
            'label': 'profile',
          },
        ),
      ],
      onChange: _onNavigationChange,
      style: FluidNavBarStyle(
        iconSelectedForegroundColor: Colors.black,
        iconUnselectedForegroundColor: Colors.grey[400],
      ),
      scaleFactor: 1.5,
      itemBuilder: (icon, item) => Semantics(
        label: icon.extras['label'],
        child: item,
      ),
    );
  }

  void _onNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
        navigation = Navigator.pushNamed(context, WelcomeScreen.id);
          break;
        case 1:
        _child = HomeScreen();
          break;
        case 2:
        _child = TicketScreen();
        navigation = Navigator.pushNamed(context, WelcomeScreen.id);
          break;
        case 3:
        _child = LoginScreen();
          break;
      }
      _child = AnimatedSwitcher(
        duration: Duration(
          milliseconds: 500,
        ),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: _child,
      );
    });
  }
}
