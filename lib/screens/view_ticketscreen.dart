import 'package:Smart_transit/fetchers/fetcher.dart';
import 'package:flutter/material.dart';
import 'ticketScreen.dart';

class ViewTicket extends StatefulWidget {
  @override
  _ViewTicketState createState() => _ViewTicketState();
}

class _ViewTicketState extends State<ViewTicket> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: getTickets(),
          builder: (context, snapshot) {
              final ticketinfo = snapshot.data;
              return SingleChildScrollView(
                child: TicketWidget(
                  paymentId: ticketinfo['paymentId'],
                  startPoint: ticketinfo['start'],
                  destinationPoint: ticketinfo['destination'],
                  ticketCode: ticketinfo['qrcode'],
                  date: ticketinfo['date'],
                  cost: ticketinfo['cost'],
                  status: ticketinfo['status'],
                ),
              );
            }
        ),
      ),
    );
  }
}
