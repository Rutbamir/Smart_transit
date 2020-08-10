import 'package:Smart_transit/screens/ticketScreen.dart';
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
              'Ticket',
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

                  return SingleChildScrollView(
                    child: TicketWidget(
                      startPoint: ticketinfo['start'],
                      destinationPoint: ticketinfo['destination'],
                      ticketCode: ticketinfo['qrcode'],
                      date: ticketinfo['date'],
                      cost: ticketinfo['cost'],
                      status: ticketinfo['status'],
                    ),
                  );
                }
              })),
    );
  }
}
