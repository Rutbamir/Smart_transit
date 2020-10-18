import 'package:Smart_transit/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:Smart_transit/get_data.dart';
import 'package:flutter_svg/flutter_svg.dart';

double cost;

class AddBottomSheet extends StatefulWidget {
  VoidCallback callback;

  AddBottomSheet({this.callback});

  _AddBottomSheetState createState() => _AddBottomSheetState();
}

class _AddBottomSheetState extends State<AddBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      width: double.infinity,
      height: 140,
      child: Padding(
        padding: const EdgeInsets.only(right: 15, left: 15, bottom: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/minus-sign.svg',
              color: Colors.grey[300],
              height: 30,
              width: 30,
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(children: [
              Text(
                'Distace: ${GetData.distance.toStringAsFixed(2)} km',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey[600],
                ),
              ),
              Spacer(),
              RichText(
                text: TextSpan(
                    text: 'Cost: ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 20.0,
                    ),
                    children: [
                      TextSpan(
                          text: 'Rs ${cost.toStringAsFixed(2)}/-',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
                          )),
                    ]),
              )
            ]),
            SizedBox(height: 25),
            Container(
              height: 40,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    elevation: 5.0,
                    child: Text(
                      'Book your ride',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PaymentScreen();
                      }));
                    },
                  ),
                  SizedBox(width: 20),
                  RaisedButton(
                    color: Colors.red[400],
                    elevation: 5.0,
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      widget.callback();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
