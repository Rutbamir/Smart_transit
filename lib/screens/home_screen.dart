import 'dart:math';
import 'package:Smart_transit/UiHelper.dart';
import 'package:Smart_transit/fetchers/fetcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String _startlocID;
  String _destLocID;

  Position _currentPosition;

  TextEditingController startAddressController = TextEditingController();
  TextEditingController destinationAddressController = TextEditingController();

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
      'assets/blackicon.png',
    );
    destinationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: 2.5,
      ),
      'assets/blackicon.png',
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
                  setState(() {
                    getMarkers();
                    setDistanceandCost();
                  });
                  showBottomSheet(
                      context: context,
                      builder: (context) {
                        return checkForDriver();
                      });
                }
              }),
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
                              value.isEmpty ? '  This can\'t be empty' : null,
                          onTap: () async {
                            List<String> result = await showSearch(
                              context: context,
                              delegate:
                                  PlacesListSearch(startAddressController),
                            );
                            if (result != null) {
                              GetData.startAddress =
                                  startAddressController.text;
                              print('Start coords: $result');
                              _startLatitude = double.parse(result[0]);
                              _startLongitude = double.parse(result[1]);
                              _startlocID = result[2];
                              print(_startlocID);
                            }
                          },
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
                              List<String> result = await showSearch(
                                context: context,
                                delegate: PlacesListSearch(
                                    destinationAddressController),
                              );
                              if (result != null) {
                                GetData.destinationAddress =
                                    destinationAddressController.text;
                                print('Destination coords: $result');
                                _destLat = double.parse(result[0]);
                                _destLong = double.parse(result[1]);
                                 _destLocID = result[2];
                              print(_destLocID);
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              )
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
    Marker marker = _markers.firstWhere((p) => p.markerId == MarkerId('Mark1'),
        orElse: () => null);

    _markers.remove(marker);
    Marker marker2 = _markers.firstWhere((p) => p.markerId == MarkerId('Mark2'),
        orElse: () => null);

    _markers.remove(marker2);
    // Start Location Marker
    Marker startMarker = Marker(
        markerId: MarkerId('Mark1'),
        position: LatLng(
          _startLatitude,
          _startLongitude,
        ),
        infoWindow: InfoWindow(
          title: 'Start',
        ),
        icon: sourceIcon);

    // Destination Location Marker
    Marker destinationMarker = Marker(
      markerId: MarkerId('Mark2'),
      position: LatLng(
        _destLat,
        _destLong,
      ),
      infoWindow: InfoWindow(
        title: 'Destination',
      ),
      icon: destinationIcon,
    );

    // Add the markers to the list
    _markers.add(startMarker);
    _markers.add(destinationMarker);

    Position _northeastCoordinates;
    Position _southwestCoordinates;

    if (_startLatitude > _destLat && _startLongitude > _destLong) {
      _southwestCoordinates =
          Position(latitude: _destLat, longitude: _destLong);
      _northeastCoordinates =
          Position(latitude: _startLatitude, longitude: _startLongitude);
    } else if (_startLongitude > _destLong) {
      _southwestCoordinates =
          Position(latitude: _startLatitude, longitude: _destLong);
      _northeastCoordinates =
          Position(latitude: _destLat, longitude: _startLongitude);
    } else if (_startLatitude > _destLat) {
      _southwestCoordinates =
          Position(latitude: _destLat, longitude: _startLongitude);
      _northeastCoordinates =
          Position(latitude: _startLatitude, longitude: _destLong);
    } else {
      _southwestCoordinates =
          Position(latitude: _startLatitude, longitude: _startLongitude);
      _northeastCoordinates =
          Position(latitude: _destLat, longitude: _destLong);
    }

    mapController.animateCamera(CameraUpdate.newLatLngBounds(
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
      100.0, // padding
    ));
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

  Widget checkForDriver() {
    return Container(
      height: 250,
      child: FutureBuilder(
          future: getDrivers(_startlocID, _destLocID),
          builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            if (snapshot.hasData && snapshot.data.length > 0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text("Drivers Available:",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                    Divider(thickness: 1),
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, int index) {
                            print(snapshot.data[index].data);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Card(
                                elevation: 2,
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Text(snapshot.data[index]["name"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      Spacer(),
                                      Text("Rating:")
                                    ],
                                  ),
                                  trailing: SizedBox(
                                    width: 40,
                                    child: Row(
                                      children: [
                                        Text(
                                            snapshot.data[index]["rating"]
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(width: 5),
                                        Icon(Icons.star,
                                            color: Colors.yellow[700]),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    GetData.driver_uid =
                                        snapshot.data[index]["uid"];
                                    Navigator.pop(context);
                                    //shows bottomsheet
                                    setState(() {
                                      _scaffoldKey.currentState
                                          .showBottomSheet<Null>(
                                              (BuildContext context) {
                                        return AddBottomSheet(
                                          callback: () {
                                            setState(() {
                                              startAddressController.clear();
                                              destinationAddressController
                                                  .clear();
                                              _markers.clear();
                                            });
                                          },
                                        );
                                      });
                                    });
                                  },
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data.isEmpty) {
              return Center(
                  child: Text('Sorry! No Rides Available.',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
