import 'package:Smart_transit/get_data.dart';
import 'package:Smart_transit/fetchers/auth.dart';
import 'package:Smart_transit/screens/dashboard.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

const chars = "abcdefghijklmnopqrstuvwxyz0123456789";

class TicketScreen extends StatefulWidget {
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
                            flex: 3,
                            child: Text('Ride Booked. Enjoy!',
                                style: TextStyle(
                                  fontSize: 25.0,
                                )),
                          ),
                          Expanded(
                            flex: 7,
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
                      child: Text("View"),
                      onPressed: () async {
                        //send ticket details to firestore
                        String uid = await _auth.getCurrentUser();
                        _firestore.collection('tickets').document(uid).setData({
                          'start': startPoint,
                          'destination': destinationPoint,
                          'qrcode': paymentId,
                          'current_lat': currentLatitude,
                          'current_long': currentLongitude,
                          'date': finalDate,
                          'uid': uid,
                          'cost': cost,
                          'status': status,
                          'paymentId': paymentId,
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

  String startPoint = GetData.startAddress;
  String destinationPoint = GetData.destinationAddress;
  double currentLatitude = GetData.currentLatitude;
  double currentLongitude = GetData.currentLongitude;
  String paymentId = GetData.paymentId;
  double cost = GetData.cost;

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
            child: TicketWidget(
              paymentId: paymentId,
              startPoint: startPoint,
              destinationPoint: destinationPoint,
              ticketCode: paymentId,
              date: dateMonthYear(),
              cost: cost,
              status: status,
            ),
          ),
        ),
      ),
    );
  }
}


  Widget TicketWidget({ 
      @required startPoint,
      @required paymentId,
      @required destinationPoint,
      @required ticketCode,
      @required date,
      @required status,
      @required cost}){
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.grey[400],
                spreadRadius: 5,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
          height: 500,
          child: Column(
            children: <Widget>[
              Expanded(
               flex: 2,
                child: Column(
                    
                    children: <Widget>[
                      Text(
                        'Your journey is from',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height:20),
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
              Expanded(
              //  flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  
                  children: <Widget>[
                    Text(
                      'Payment Id: ',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Text('${GetData.paymentId}',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ), )
                  ],
                ),
              ),
              Divider(
                color: Colors.grey[400],
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
                    date,
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
                    data: paymentId,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Ticket Status: $status',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
    );
  }

