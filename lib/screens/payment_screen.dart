import 'package:Smart_transit/get_data.dart';
import 'package:Smart_transit/screens/bottomSheet.dart';
import 'package:Smart_transit/screens/ticketScreen.dart';
import 'package:Smart_transit/widgets/pymnt_dialog_response.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

//pwd for razorpay Razorpay@smarttransit1

class PaymentScreen extends StatefulWidget {
  PaymentScreen({Key key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Razorpay razorpay;

  @override
  void initState() {
    super.initState();

    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExtenalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void openCheckout() async {
    //amount is in paisa(needs to be multiplied by 100)
    double x = cost * 100;
    int tktCost = x.toInt();
    var options = {
      "key": "rzp_test_KtTxqGSjkN2tvf",
      "amount": tktCost,
      "name": "Smart Transit",
      "description": "Payment for your Ride.",
      "prefill": {"contact": "2323232323", "email": "shdjsdh@gmail.com"},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    GetData.paymentId = response.paymentId;
    _showDialog(id: GetData.paymentId);
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return TicketScreen();
        }));
      });
    });
  }

  void handlerErrorFailure(PaymentFailureResponse response) {
    print("payment Failure");
  }

  void handlerExtenalWallet(ExternalWalletResponse response) {
    print("External Wallet");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: GoogleFonts.montserratTextTheme(),
        title: Text(
          'Payment',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Amount to be paid Rs.${cost.toStringAsFixed(2)}.'),
            ),
            Center(
              child: RaisedButton(
                color: Colors.blue,
                child: Text(
                  "Pay Now",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  openCheckout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog({String id}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogResponses(
          color: Colors.green[300],
          icon: Icons.check_circle,
          message: "Transaction Successfull,\n redirecting to ticket",
          id: id,
        );
      },
    );
  }
}
