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

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){},
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Status: ',
                                      ),
                                      Text(
                                        '${ticketinfo['status']}',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Date: ',
                                      ),
                                      Text(
                                        '${ticketinfo['date']}',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Cost: ',
                                      ),
                                      Text(
                                        '${ticketinfo['cost'].toStringAsFixed(2)}',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'From: ',
                                      ),
                                      Text(
                                        '${ticketinfo['start']}',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'To: ',
                                      ),
                                      Text(
                                        '${ticketinfo['destination']}',
                                      ),
                                    ],
                                  ),
                                ],
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
// SingleChildScrollView(
//                     child: TicketWidget(
//                       paymentId: ticketinfo['paymentId'],
//                       startPoint: ticketinfo['start'],
//                       destinationPoint: ticketinfo['destination'],
//                       ticketCode: ticketinfo['qrcode'],
//                       date: ticketinfo['date'],
//                       cost: ticketinfo['cost'],
//                       status: ticketinfo['status'],
//                     ),
//                   );
