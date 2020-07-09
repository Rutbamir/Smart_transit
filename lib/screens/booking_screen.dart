import 'package:flutter/material.dart';
import 'package:login/constants.dart';
class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Bookings "),
        flexibleSpace: Container(decoration: kgradientDecoration),
        backgroundColor: Color.fromRGBO(251, 92, 0, 1),
      ),
    );
  }
}
