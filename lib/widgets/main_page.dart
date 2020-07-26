import 'package:Smart_transit/screens/home_screen.dart';
import 'package:Smart_transit/screens/login_screen.dart';
import 'package:Smart_transit/screens/myBookings.dart';
import 'package:Smart_transit/screens/ticketScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  static String id = 'main_page';
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget _child;
  PageController _pageController = PageController();
  List<Widget> _screens = [
    HomeScreen(),
    LoadTicket(),
    TicketScreen(),
    LoginScreen(),
  ];

  int _selectedIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
    _child = AnimatedSwitcher(
      duration: Duration(
        milliseconds: 500,
      ),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: FluidNavBar(
        onChange: _onItemTapped,
        icons: [
          FluidNavBarIcon(
            iconPath: 'assets/home.svg',
            backgroundColor: Colors.white,
            extras: {'label': 'home'},
          ),
          FluidNavBarIcon(
            iconPath: 'assets/pin.svg',
            backgroundColor: Colors.white,
            extras: {'label': 'map'},
          ),
          FluidNavBarIcon(
            iconPath: 'assets/bus.svg',
            backgroundColor: Colors.white,
            extras: {'label': 'my bookings'},
          ),
          FluidNavBarIcon(
            iconPath: 'assets/profile.svg',
            backgroundColor: Colors.white,
            extras: {'label': 'profile'},
          ),
        ],
        style: FluidNavBarStyle(
          iconSelectedForegroundColor: Colors.black,
          iconUnselectedForegroundColor: Colors.grey[400],
        ),
        scaleFactor: 1.5,
        itemBuilder: (icon, item) => Semantics(
          label: icon.extras['label'],
          child: item,
        ),
      ),
    );
  }
}