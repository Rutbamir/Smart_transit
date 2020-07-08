import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:login/constants.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  
  static const LatLng _center = LatLng(34.115829, 74.859138);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: Drawer(
            child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: kgradientDecoration,
              accountName: Text('Someone'),
              accountEmail: Text('someone@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset('assets/user.jpg'),
                ),
              ),
            ),
            ListTile(
                title: Text("My Bookings"),
                leading: Icon(Icons.book),
                onTap: () {
                  print('functionality to be added');
                }),
            ListTile(
              title: Text("Settings"),
              leading: Icon(Icons.settings),
            ),
            ListTile(
              title: Text("Log Out"),
              leading: Icon(Icons.exit_to_app),
            ),
          ],
        )),
        appBar: AppBar(
          flexibleSpace: Container(decoration: kgradientDecoration),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                //functionality to be added
                Prediction prediction = await PlacesAutocomplete.show(
                    context: context, apiKey: kGoogleApiKey);
                displayPrediction(prediction);
              },
            ),
          ],
          backgroundColor: Color.fromRGBO(251, 92, 0, 1),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 11.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);
      print(lat);
      print(lng);
    }
=======
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: kgradientDecoration,
                  accountName: Text('Someone'),
                  accountEmail: Text('someone@gmail.com'),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset('assets/user.jpg'),
                    ),
                  ),
                ),
                ListTile(
                    title: Text("My Bookings"),
                    leading: Icon(Icons.book),
                    onTap: () {
                      print('functionality to be added');
                    }),
                ListTile(
                  title: Text("Settings"),
                  leading: Icon(Icons.settings),
                ),
                ListTile(
                  title: Text("Log Out"),
                  leading: Icon(Icons.exit_to_app),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            flexibleSpace: Container(decoration: kgradientDecoration),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  //functionality to be added
                  print('searching');
                },
              ),
            ],
            backgroundColor: Color.fromRGBO(251, 92, 0, 1),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 11.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
>>>>>>> b4a04dcbe8039ed94c883ccd08184d5d288ded50
  }
}
