import 'package:Smart_transit/UiHelper.dart';
import 'package:Smart_transit/get_data.dart';
import 'package:Smart_transit/fetchers/auth.dart';
import 'package:Smart_transit/screens/dashboard.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

const chars = "abcdefghijklmnopqrstuvwxyz0123456789";

class TicketScreen extends StatefulWidget {
  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  UiHelper _uiHelper = UiHelper();
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
                          Text('Ride Booked. Enjoy!',
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              )),
                          Expanded(
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
                      child: Text("View", style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        //send ticket details to firestore
                        String uid = await _auth.getCurrentUser();
                        _firestore
                            .collection('users')
                            .document(uid)
                            .collection('tickets')
                            .document(GetData.paymentId)
                            .setData({
                          'start': GetData.startAddress,
                          'destination': GetData.destinationAddress,
                          'qrcode': GetData.paymentId,
                          'current_lat': GetData.currentLatitude,
                          'current_long': GetData.currentLongitude,
                          'date': finalDate,
                          'uid': uid,
                          'cost': GetData.cost,
                          'status': status,
                          'paymentId': GetData.paymentId,
                          'driver_id': GetData.driver_uid,
                        });
                        await _firestore
                            .collection('tickets')
                            .document(GetData.paymentId)
                            .setData({
                          'start': GetData.startAddress,
                          'destination': GetData.destinationAddress,
                          'qrcode': GetData.paymentId,
                          'current_lat': GetData.currentLatitude,
                          'current_long': GetData.currentLongitude,
                          'date': finalDate,
                          'uid': uid,
                          'cost': GetData.cost,
                          'status': status,
                          'paymentId': GetData.paymentId,
                          'driver_id': GetData.driver_uid,
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
  // var ticketCode = '';
  String status = 'Issued';

  AuthService _auth = AuthService();
  final _firestore = Firestore.instance;

  //generates random characters
  // String randomString(int strlen) {
  //   Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  //   String result = "";
  //   for (var i = 0; i < strlen; i++) {
  //     result += chars[rnd.nextInt(chars.length)];
  //   }
  //   ticketCode = result;
  //   GetData.qrCode = paymentId;
  //   return result;
  // }

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
            textTheme: Theme.of(context).textTheme,
            title: Text(
              'Ticket',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Dashboard();
                }));
              },
            ),
          ),
          body: SingleChildScrollView(
            child: _uiHelper.TicketWidget(
              paymentId: GetData.paymentId,
              startPoint: GetData.startAddress,
              destinationPoint: GetData.destinationAddress,
              ticketCode: GetData.paymentId,
              date: dateMonthYear(),
              cost: GetData.cost,
              status: status,
            ),
          ),
        ),
      ),
    );
  }
}
