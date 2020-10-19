import 'package:Smart_transit/UiHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ViewTicket extends StatelessWidget {
   UiHelper _uiHelper = UiHelper();
  DocumentSnapshot ticket;
  ViewTicket({@required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: 

                 _uiHelper.TicketWidget(
                  paymentId: ticket['paymentId'],
                  startPoint: ticket['start'],
                  destinationPoint: ticket['destination'],
                  ticketCode: ticket['qrcode'],
                  date: ticket['date'],
                  cost: ticket['cost'],
                  status: ticket['status'],
                )
                );
              }
            }
