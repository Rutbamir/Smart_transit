import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UiHelper {
  Widget getLoading() {
    return Container(
      color: Colors.white,
      child: Center(
          child: CircularProgressIndicator()),
    );
  }

  Widget getTextField(
      {@required Function onTap,
      @required TextEditingController controller,
      @required String hint,
      @required Function validator}) {
    return TextFormField(
      validator: validator,
      onTap: onTap,
      textAlign: TextAlign.center,
      controller: controller,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400])),
    );
  }

  Widget TicketWidget(
      {@required startPoint,
      @required paymentId,
      @required destinationPoint,
      @required ticketCode,
      @required date,
      @required status,
      @required cost}) {
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
                    SizedBox(height: 20),
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
                    Text(
                      paymentId,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
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
   Widget tryAgainDialog(context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              height: 90,
              width: 180,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                    Text("Please Try Again")
                  ],
                ),
              ),
            ),
          );
        });

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }
   Widget showLoading(context) {
    showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              height: 90,
              width: 180,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircularProgressIndicator(),
                    Text("Please wait...")
                  ],
                ),
              ),
            ),
          );
        });
  }
}
