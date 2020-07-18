import 'package:Smart_transit/screens/ticketScreen.dart';
import 'package:flutter/material.dart';
import 'package:Smart_transit/addresses.dart';

class AddBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.grey[600],
              spreadRadius: 5,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 18.0,
            top: 10.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Icon goes here/new font good?',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Here are your ticket details',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Expanded(child: RaisedButton(onPressed: () {
                Navigator.pushNamed(context, TicketScreen.id);
              })),
            ],
          ),
        ),
      ),
    );
  }
}
