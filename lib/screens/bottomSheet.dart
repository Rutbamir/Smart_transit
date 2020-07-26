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
      height: 200,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.grey[400],
            ),
          ],
          color: Color(0XFF405289),
          // Theme.of(context).primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 18.0,
            bottom: 18.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: SvgPicture.asset(
                  'assets/minus-sign.svg',
                  color: Colors.grey[300],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'Distance: ${GetData.distance.toStringAsFixed(2)} km',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '₹ ${cost.toStringAsFixed(2)}/-',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Color(0XFffff35e),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Spacer(),

              Expanded(
                child: Container(
                  width: 300,
                  child: RaisedButton(
                    color: Colors.white,
                    elevation: 1.0,
                    child: Text(
                      'Book your ride',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
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
            ],
          ),
        ),
      ),
    );
  }
}
