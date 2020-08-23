import 'package:flutter/material.dart';

class DialogResponses extends StatefulWidget {
  Color color;
  IconData icon;
  String id;
  String message;
  DialogResponses({this.color, this.icon, this.id, this.message});
  @override
  _DialogResponsesState createState() => _DialogResponsesState();
}

class _DialogResponsesState extends State<DialogResponses> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent, //this right here
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width * 0.55,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment(0, 1),
              child: Container(
                height: 160,
                width: MediaQuery.of(context).size.width * 0.55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  color: Colors.white,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.message,
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      widget.id == null
                          ? Container()
                          : Text(
                              "ID: ${widget.id}",
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, -1),
              child: Container(
                height: 80,
                width: 80,
                decoration:
                    BoxDecoration(color: widget.color, shape: BoxShape.circle),
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
