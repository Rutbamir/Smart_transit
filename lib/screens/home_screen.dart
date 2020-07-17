import 'package:Smart_transit/constants.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:Smart_transit/widgets/drawer.dart';
import '../widgets/textFields.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'places_delegate.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(34.115829, 74.859138));

  GoogleMapController mapController;
  final Geolocator _geolocator = Geolocator();

  Position _currentPosition;
  String _currentAddress;

  TextEditingController startAddressController = TextEditingController();
  TextEditingController destinationAddressController = TextEditingController();

  String _startAddress = '';
  String _destinationAddress = '';

  Set<Marker> _markers = {};

  PolylinePoints polylinePoints;
// this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        height: height,
        width: width,
        child: Scaffold(
          key: _drawerKey,
          drawer: MyDrawer(),
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              // the main map
              GoogleMap(
                markers: _markers != null ? Set<Marker>.from(_markers) : null,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                myLocationEnabled: true,
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: _initialLocation,
                polylines: Set<Polyline>.of(polylines.values),
              ),

              //Drawer icon
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.blue[800],
                      size: 30.0,
                    ),
                    onPressed: () {
                      _drawerKey.currentState.openDrawer();
                    },
                  ),
                ),
              ),

              //Current Location
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0, right: 20.0),
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange[100], // button color
                      child: InkWell(
                        splashColor: Colors.orange, // inkwell color
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(
                            Icons.my_location,
                          ),
                        ),
                        onTap: () {
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  _currentPosition.latitude,
                                  _currentPosition.longitude,
                                ),
                                zoom: 16.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 60.0, right: 30.0, left: 30.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  alignment: Alignment.topCenter,
                  height: 115,
                  width: width * 0.8,
                  child: Column(
                    children: <Widget>[
                      MyTextWidget(
                        hint: 'Your Current Location',
                        controller: startAddressController,
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.my_location,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            setState(
                              () {
                                startAddressController.text = _currentAddress;
                                _startAddress = _currentAddress;
                                print(_currentAddress);
                              },
                            );
                          },
                        ),
                      ),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                        color: Colors.orange,
                      ),
                      MyTextWidget(
                        hint: 'Your Destination',
                        //add location predictor
                        ontap: () {
                          showSearch(
                            context: context,
                            delegate:
                                PlacesListSearch(destinationAddressController),
                          );
                          _destinationAddress =
                              destinationAddressController.text;
                          print(_destinationAddress);
                          geocode();
                        },
                        prefixIcon: Icon(
                          Icons.flag,
                          color: Colors.orange,
                        ),
                        controller: destinationAddressController,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POSITION: $_currentPosition');

        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 13.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  //method for retrieving the address
  _getAddress() async {
    try {
      var address = await _geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      var first = address.first;

      setState(() {
        _currentAddress = "${first.subLocality}, ${first.locality}";

        startAddressController.text = _currentAddress;

        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  // Getting the placemarks
  Future<dynamic> geocode() async {
    try {
      List<Placemark> startPlacemark =
          await _geolocator.placemarkFromAddress(_startAddress);
      List<Placemark> destinationPlacemark =
          await _geolocator.placemarkFromAddress(_destinationAddress);

      // Retrieving coordinates

      if (startPlacemark != null && destinationPlacemark != null) {
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        Position startCoordinates = _startAddress == _currentAddress
            ? Position(
                latitude: _currentPosition.latitude,
                longitude: _currentPosition.longitude,
              )
            : startPlacemark[0].position;
        Position destinationCoordinates = destinationPlacemark[0].position;
        print(startCoordinates);
        print(destinationCoordinates);

        // Start Location Marker
        Marker startMarker = Marker(
          markerId: MarkerId('$startCoordinates'),
          position: LatLng(
            startCoordinates.latitude,
            startCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start',
            snippet: _startAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

// Destination Location Marker
        Marker destinationMarker = Marker(
          markerId: MarkerId('$destinationCoordinates'),
          position: LatLng(
            destinationCoordinates.latitude,
            destinationCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: _destinationAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Add the markers to the list
        _markers.add(startMarker);
        _markers.add(destinationMarker);

        //define two position variables for map orientation
        Position _northeastCoordinates;
        Position _southwestCoordinates;

        // Calculating to check that
        // southwest coordinate <= northeast coordinate
        if (startCoordinates.latitude <= destinationCoordinates.latitude) {
          _southwestCoordinates = startCoordinates;
          _northeastCoordinates = destinationCoordinates;
        } else {
          _southwestCoordinates = destinationCoordinates;
          _northeastCoordinates = startCoordinates;
        }
        // Accommodate the two locations within the camera view of the map
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(
                _northeastCoordinates.latitude,
                _northeastCoordinates.longitude,
              ),
              southwest: LatLng(
                _southwestCoordinates.latitude,
                _southwestCoordinates.longitude,
              ),
            ),
            100.0, //padding
          ),
        );
        await createPolylines(startCoordinates, destinationCoordinates);
      }
    } catch (e) {
      print(e);
    }
  }

  // creates polylines
  createPolylines(Position start, Position destination) async {
    try {
      polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        kGoogleApiKey,
        PointLatLng(start.latitude, start.longitude),
        PointLatLng(destination.latitude, destination.longitude),
        travelMode: TravelMode.transit,
      );
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }

      setState(() {
        PolylineId id = PolylineId('poly');
        Polyline polyline = Polyline(
          polylineId: id,
          color: Colors.lightBlueAccent,
          points: polylineCoordinates,
          width: 3,
        );
        polylines[id] = polyline;
      });
    } catch (e) {
      print(e);
    }
  }
}
