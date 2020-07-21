import 'package:Smart_transit/screens/ticketScreen.dart';
import 'package:flutter/material.dart';
import 'package:Smart_transit/get_data.dart';
import 'package:flutter_svg/flutter_svg.dart';

double cost;

class AddBottomSheet extends StatefulWidget {
  _AddBottomSheetState createState() => _AddBottomSheetState();
}

class _AddBottomSheetState extends State<AddBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.grey[600],
              spreadRadius: 5,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 18.0,
            top: 10.0,
            bottom: 18.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: SvgPicture.asset(
                  'assets/minus-sign.svg',
                  color: Colors.grey[300],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Distace: ${GetData.distance.toStringAsFixed(2)} km',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Cost: Rs ${cost.toStringAsFixed(2)}/-',
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 250,
                    child: RaisedButton(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Book your ride',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          TicketScreen.id,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
