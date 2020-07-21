import 'package:Smart_transit/get_data.dart';
import 'package:Smart_transit/constants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'bottomSheet.dart';
import 'dart:core';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

const chars = "abcdefghijklmnopqrstuvwxyz0123456789";

class TicketScreen extends StatefulWidget {
  static String id = 'ticket_screen';

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  @override
  void initState() {
    super.initState();

    //shows success alert dialog
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => WillPopScope(
                onWillPop: () async => false,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  content: Container(
                      height: 200,
                      width: 300,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text('Ride Booked. Enjoy!',
                                style: TextStyle(
                                  fontSize: 25.0,
                                )),
                          ),
                          Expanded(
                            flex: 6,
                            child: FlareActor(
                              'assets/success.flr',
                              alignment: Alignment.center,
                              animation: "Untitled",
                            ),
                          ),
                        ],
                      )),
                  actions: <Widget>[
                    FlatButton(
                      child: new Text("View"),
                      onPressed: () {
                        //send ticket details to firestore
                        _firestore
                            .collection('tickets')
                            .document(krandomNumber())
                            .setData({
                          'start': startPoint,
                          'destination': destinationPoint,
                          'qrcode': ticketCode,
                          'current_lat': currentLatitude,
                          'current_long': currentLongitude,
                          'date': finalDate,
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ));
    });
  }

  String finalDate = '';
  var ticketCode = '';
  final _firestore = Firestore.instance;

  String startPoint = GetData.startAddress;
  String destinationPoint = GetData.destinationAddress;
  double currentLatitude = GetData.currentLatitude;
  double currentLongitude = GetData.currentLongitude;

  //generates random characters
  String randomString(int strlen) {
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    ticketCode = result;
    GetData.qrCode = ticketCode;
    return result;
  }

  //date function
  String dateMonthYear() {
    var date = DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    finalDate = formattedDate;
    return finalDate;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
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
          body: SingleChildScrollView(
            child: Column(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'Your journey is from',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            Text(
                              "$startPoint to $destinationPoint",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Dated: ',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            dateMonthYear(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey[400],
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'Bus Service',
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  'Omnibus',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey[400],
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            Text(
                              'Your ticket price is Rs ${cost.toStringAsFixed(2)}/-',
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                      Text(
                        ticketCode,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                    right: 20.0,
                    left: 20.0,
                  ),
                  child: Text(
                    'Please show above QR code while boarding the bus.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
