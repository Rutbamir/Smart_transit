import 'package:Smart_transit/models/auth.dart';
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

Future<DocumentSnapshot> getTickets() async {
  String uid = await _auth.getCurrentUser();
  final tickets = await _firestore.collection('tickets').document('$uid').get();
  return tickets;
}
