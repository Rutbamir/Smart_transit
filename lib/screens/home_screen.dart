import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Smart_transit/get_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Smart_transit/widgets/drawer.dart';
import '../widgets/textFields.dart';
import 'bottomSheet.dart';
import 'places_delegate.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(34.115829, 74.859138));

  GoogleMapController mapController;
  final Geolocator _geolocator = Geolocator();

  Position _currentPosition;
  String _currentAddress;

  Position _startCoordinates;
  Position _destinationCoordinates;

  TextEditingController startAddressController = TextEditingController();
  TextEditingController destinationAddressController = TextEditingController();

  String _startAddress = '';
  String _destinationAddress = '';
  String _placeDistance;

  Set<Marker> _markers = {};

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    setCustomMarkers();
    getCurrentUser();
  }

  void setCustomMarkers() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: 2.5,
      ),
      'assets/marker.png',
    );
    destinationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: 2.5,
      ),
      'assets/marker.png',
    );
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
          key: _scaffoldKey,
          drawer: MyDrawer(),
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              // the main map
              GoogleMap(
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                myLocationEnabled: true,
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: _initialLocation,
              ),

              //Drawer icon
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/menu.svg',
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
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
                        splashColor: Colors.lightBlueAccent, // inkwell color
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
                  height: 160,
                  width: width * 0.8,
                  child: Column(
                    children: <Widget>[
                      MyTextWidget(
                        hint: 'Your Current Location',
                        controller: startAddressController,
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.my_location,
                            color: Colors.black,
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
                        color: Colors.blue[600],
                      ),
                      MyTextWidget(
                        hint: 'Your Destination',
                        controller: destinationAddressController,
                        //add location predictor
                        ontap: () {
                          showSearch(
                            context: context,
                            delegate:
                                PlacesListSearch(destinationAddressController),
                          );
                        },
                        prefixIcon: Icon(
                          Icons.flag,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.directions_bus,
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            await geocode();

                            //shows bottomsheet
                            setState(() {
                              _scaffoldKey.currentState.showBottomSheet<Null>(
                                  (BuildContext context) {
                                return AddBottomSheet();
                              });
                            });
                          }),
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
        GetData.currentLatitude = _currentPosition.latitude;
        GetData.currentLongitude = _currentPosition.longitude;

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

        GetData.startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  // Getting the placemarks
  Future<dynamic> geocode() async {
    try {
      _destinationAddress = destinationAddressController.text;
      GetData.destinationAddress = destinationAddressController.text;
      print(_destinationAddress);
      List<Placemark> startPlacemark =
          await _geolocator.placemarkFromAddress(_startAddress);
      List<Placemark> destinationPlacemark =
          await _geolocator.placemarkFromAddress(_destinationAddress);

      // Retrieving coordinates

      if (startPlacemark != null && destinationPlacemark != null) {
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        _startCoordinates = _startAddress == _currentAddress
            ? Position(
                latitude: _currentPosition.latitude,
                longitude: _currentPosition.longitude,
              )
            : startPlacemark[0].position;
        _destinationCoordinates = destinationPlacemark[0].position;
        print(_startCoordinates);
        print(_destinationCoordinates);

        setDistanceandCost();

        // Start Location Marker
        Marker startMarker = Marker(
            markerId: MarkerId('$_startCoordinates'),
            position: LatLng(
              _startCoordinates.latitude,
              _startCoordinates.longitude,
            ),
            infoWindow: InfoWindow(
              title: 'Start',
              snippet: _startAddress,
            ),
            icon: sourceIcon);

        // Destination Location Marker
        Marker destinationMarker = Marker(
          markerId: MarkerId('$_destinationCoordinates'),
          position: LatLng(
            _destinationCoordinates.latitude,
            _destinationCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: _destinationAddress,
          ),
          icon: destinationIcon,
        );

        // Add the markers to the list
        _markers.add(startMarker);
        _markers.add(destinationMarker);

//IMP DON'T DELETE
        // Calculating the total distance by adding the distance
        // between small segments
        // for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        //   totalDistance += _coordinateDistance(
        //     polylineCoordinates[i].latitude,
        //     polylineCoordinates[i].longitude,
        //     polylineCoordinates[i + 1].latitude,
        //     polylineCoordinates[i + 1].longitude,
        //   );
        // }

      }
    } catch (e) {
      print(e);
    }
  }

  void setDistanceandCost() {
    double totalDistance = 0.0;

    double _coordinateDistance(lat1, lon1, lat2, lon2) {
      double dlong = lon2 - lon1;
      double dlat = lat2 - lat1;

//IMP DON'T DELETE
      // var p = 0.017453292519943295;
      // var c = cos;
      // var a = 0.5 -
      //     c((lat2 - lat1) * p) / 2 +
      //     c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      double ans = pow(sin(dlat / 2), 2) +
          cos(lat1) * cos(lat2) * pow(sin(dlong / 2), 2);
//IMP DON'T DELETE
      // return 12742 * asin(sqrt(a));
      ans = 2 * asin(sqrt(ans));
      double r = 6371;
      ans = ans * r;
      return ans;
    }

    double lat1 = _startCoordinates.latitude / 57.29577951;
    double lat2 = _destinationCoordinates.latitude / 57.29577951;

    double long1 = _startCoordinates.longitude / 57.29577951;
    double long2 = _destinationCoordinates.longitude / 57.29577951;

    totalDistance = _coordinateDistance(lat1, long1, lat2, long2);

    setState(() {
      _placeDistance = totalDistance.toStringAsFixed(2);
      GetData.distance = totalDistance;
      print('DISTANCE: ${GetData.distance} km');
      cost = GetData.distance * 5;
      print('cost: $cost');
    });
  }
}
