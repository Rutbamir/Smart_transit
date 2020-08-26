import 'package:Smart_transit/screens/ticketScreen.dart';
import 'package:Smart_transit/screens/view_ticketscreen.dart';
import 'package:flutter/material.dart';
import 'package:Smart_transit/fetchers/fetcher.dart';

class LoadTicket extends StatefulWidget {
  @override
  _LoadTicketState createState() => _LoadTicketState();
}

class _LoadTicketState extends State<LoadTicket> {
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
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
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
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: Text('No Ticket Issued.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 30.0,
                          )));
                } else {
                  final ticketinfo = snapshot.data;

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ViewTicket();
                                },
                              ),
                            );
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
                                          info: '${ticketinfo['date']}',
                                        ),
                                        Spacer(),
                                        Text(
                                          '₹ ${ticketinfo['cost'].toStringAsFixed(2)}',
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
                                      info: '${ticketinfo['status']}',
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        BookingCardInfo(
                                          heading: 'From: ',
                                          info: '${ticketinfo['start']}',
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        BookingCardInfo(
                                          heading: 'To: ',
                                          info: '${ticketinfo['destination']}',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: 1,
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
        Text(
          info,
        ),
      ],
    );
  }
}

