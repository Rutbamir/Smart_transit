import 'package:cloud_firestore/cloud_firestore.dart';

Firestore _firestore = Firestore.instance;

Future<List<Map>> getplaces() async {
  List<Map> myplaces = []; //it holds the snapshots
  final places = await _firestore.collection('places').getDocuments();
  for (var place in places.documents) {
    print(place.data);
    myplaces.add(place.data);
  }
  return myplaces;
}
