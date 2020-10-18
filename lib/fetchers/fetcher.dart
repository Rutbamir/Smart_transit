import 'package:Smart_transit/fetchers/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Firestore _firestore = Firestore.instance;
AuthService _auth = AuthService();

Future<List<Map>> getplaces() async {
  List<Map> myplaces = []; //it holds the snapshots
  final places = await _firestore.collection('places').getDocuments();
  for (var place in places.documents) {
    myplaces.add(place.data);
  }
  return myplaces;
}

Future<List<DocumentSnapshot>> getTickets() async {
  String uid = await _auth.getCurrentUser();
  QuerySnapshot tickets = await _firestore
      .collection('users')
      .document('$uid')
      .collection('tickets')
      .orderBy("paymentId", descending: true)
      .getDocuments();
  print(tickets.documents);
  return tickets.documents;
}

Future<List<DocumentSnapshot>> getDrivers(String currentLocation) async {
  QuerySnapshot snap = await _firestore
      .collection("drivers")
      .where("current_location", isEqualTo: currentLocation)
      .where("in_transit", isEqualTo: false)
      .getDocuments();
  return snap.documents;
}
