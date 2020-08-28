import 'package:Smart_transit/UiHelper.dart';
import 'package:Smart_transit/screens/ticketScreen.dart';
import 'package:Smart_transit/screens/view_ticketscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Smart_transit/fetchers/fetcher.dart';

class LoadTicket extends StatefulWidget {
  @override
  _LoadTicketState createState() => _LoadTicketState();
}

class _LoadTicketState extends State<LoadTicket> {
  UiHelper _uiHelper = UiHelper();
  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color.fromRGBO(212, 208, 207, 1),
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            textTheme: Theme.of(context).textTheme,
            title: Text(
              'My Bookings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: FutureBuilder(
              future: getTickets(),
              builder:
                  (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    !snapshot.hasData) {
                  return Center(
                      child: Text('No Ticket Issued.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 30.0,
                          )));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return _uiHelper.getLoading();
                } else {
                  List<DocumentSnapshot> ticketinfo = snapshot.data;

                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ViewTicket(ticket: ticketinfo[index]);
                            },
                          ));
                        },
                        child: Container(
                          height: 150,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        BookingCardInfo(
                                          heading: 'Date: ',
                                          info: '${ticketinfo[index]['date']}',
                                        ),
                                        Spacer(),
                                        Text(
                                          '₹ ${ticketinfo[index]['cost'].toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    BookingCardInfo(
                                      heading: 'Status: ',
                                      info: '${ticketinfo[index]['status']}',
                                    ),
                                    BookingCardInfo(
                                      heading: 'From: ',
                                      info: '${ticketinfo[index]['start']}',
                                    ),
                                    BookingCardInfo(
                                      heading: 'To: ',
                                      info:
                                          '${ticketinfo[index]['destination']}',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              })),
    );
  }
}

class BookingCardInfo extends StatelessWidget {
  const BookingCardInfo({
    Key key,
    @required this.heading,
    @required this.info,
  }) : super(key: key);

  final heading;
  final info;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          heading,
        ),
        Text(info, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
