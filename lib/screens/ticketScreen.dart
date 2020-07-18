import 'package:Smart_transit/addresses.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'home_screen.dart';
import 'dart:core';
import 'dart:math';

const chars = "abcdefghijklmnopqrstuvwxyz0123456789";

class TicketScreen extends StatefulWidget {
  static String id = 'ticket_screen';

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  var ticketCode = '';

  //generates random characters
  String randomString(int strlen) {
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    ticketCode = result;
    return result;
  }

  //date function
  String dateMonthYear() {
    var date = DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    String finalDate = formattedDate;
    return finalDate;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(212, 208, 207, 1),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('Ticket'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )),
              height: 500,
              child: Column(
                children: <Widget>[
                  Text(GetAddress.startAddress),
                  Text(GetAddress.destinationAddress),
                  Expanded(
                    flex: 2,
                    child: Text(dateMonthYear(),
                        style: TextStyle(
                          fontSize: 30.0,
                        )),
                  ),
                  Divider(
                    color: Colors.grey[400],
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: <Widget>[
                        Text('Bus Service',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text('Omnibus',
                            style: TextStyle(
                              fontSize: 15.0,
                            )),
                      ],
                    ),
                  ),
                  Divider(),
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: 150.0,
                      height: 150.0,
                      child: QrImage(
                        data: randomString(10),
                      ),
                    ),
                  ),
                  Text(ticketCode),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, right: 20.0, left: 20.0),
              child: Text('Please show above QR code while boarding the bus.',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
