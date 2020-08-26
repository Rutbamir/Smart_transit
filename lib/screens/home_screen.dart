import 'dart:math';
import 'package:Smart_transit/UiHelper.dart';
import 'package:Smart_transit/fetchers/auth.dart';
import 'package:flutter/material.dart';
import 'package:Smart_transit/get_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'bottomSheet.dart';
import 'places_delegate.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UiHelper _uiHelper = UiHelper();

  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(34.115829, 74.859138));

  GoogleMapController mapController;
  Geolocator _geolocator = Geolocator();

  double _startLatitude;
  double _startLongitude;
  double _destLat;
  double _destLong;

  Position _currentPosition;

  TextEditingController startAddressController = TextEditingController();
  TextEditingController destinationAddressController = TextEditingController();

  String _startAddress = '';
  String _destinationAddress = '';

  Set<Marker> _markers = {};

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    setCustomMarkers();
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
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.directions_bus,
            ),
            backgroundColor: Theme.of(context).accentColor,
            onPressed: () {
              bool validation = _formKey.currentState.validate();
              if (validation == true) {
                getMarkers();
                setDistanceandCost();
                //shows bottomsheet
                setState(() {
                  _scaffoldKey.currentState
                      .showBottomSheet<Null>((BuildContext context) {
                    return AddBottomSheet();
                  });
                });
              }
            },
          ),
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
              //Current Location
              Positioned(
                bottom: 70.0,
                right: 16.0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, left: 20.0),
                  child: Container(
                    child: ClipOval(
                      child: Material(
                        color: Colors.white, // button color
                        child: InkWell(
                          splashColor: Colors.lightBlueAccent, // inkwell color
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(
                              Icons.my_location,
                              color: Colors.blue,
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
                                  zoom: 18.0,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 60,
                left: 30,
                right: 30,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.grey[400],
                        offset: Offset(2, 2),
                        spreadRadius: 2,
                      ),
                    ],
                  ),

                  // height: 170,
                  width: width * 0.8,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _uiHelper.getTextField(
                          hint: 'Your Pickup Location',
                          controller: startAddressController,
                          validator: (value) =>
                              value.isEmpty ?  '  Email can\'t be empty' : null,
                          onTap: () async {
                            final List<double> result = await showSearch(
                              context: context,
                              delegate:
                                  PlacesListSearch(startAddressController),
                            );

                            GetData.startAddress = startAddressController.text;
                            print('Start coords: $result');
                            _startLatitude = result[0];
                            _startLongitude = result[1];
                          },
                          // icon: Icon(
                          //   Icons.my_location,
                          //   color: Colors.blue,
                          // ),
                        ),
                        Divider(
                          indent: 20,
                          endIndent: 20,
                          color: Colors.grey[500],
                        ),
                        _uiHelper.getTextField(
                          hint: 'Your Destination',
                          controller: destinationAddressController,
                          validator: (value) =>
                              value == startAddressController.text
                                  ? '  Start and Dest cannot be same \n'
                                  : null,

                          //add location predictor
                          onTap: () async {
                            final List<double> result = await showSearch(
                              context: context,
                              delegate: PlacesListSearch(
                                  destinationAddressController),
                            );
                            GetData.destinationAddress =
                                destinationAddressController.text;
                            print('Destination coords: $result');
                            _destLat = result[0];

                            _destLong = result[1];
                          },

                          // icon: Icon(
                          //   Icons.flag,
                          //   color: Colors.blue,
                          // ),
                        ),
                      ],
                    ),
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
              zoom: 18.0,
            ),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });
  }

  //build markers
  getMarkers() {
    // Start Location Marker
    Marker startMarker = Marker(
        markerId: MarkerId('$_startLatitude, $_startLongitude'),
        position: LatLng(
          _startLatitude,
          _startLongitude,
        ),
        infoWindow: InfoWindow(
          title: 'Start',
          snippet: _startAddress,
        ),
        icon: sourceIcon);

    // Destination Location Marker
    Marker destinationMarker = Marker(
      markerId: MarkerId('$_destLat, $_destLong'),
      position: LatLng(
        _destLat,
        _destLong,
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

    print('this is start lat $_startLatitude');
    double lat1 = _startLatitude / 57.29577951;
    double lat2 = _destLat / 57.29577951;

    double long1 = _startLongitude / 57.29577951;
    double long2 = _destLong / 57.29577951;

    totalDistance = _coordinateDistance(lat1, long1, lat2, long2);

    setState(() {
      // _placeDistance = totalDistance.toStringAsFixed(2);
      GetData.distance = totalDistance;
      print('DISTANCE: ${GetData.distance} km');
      cost = GetData.distance * 5;
      GetData.cost = cost;
      print('cost: $cost');
    });
  }
}
