import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:login/widgets/drawer.dart';
import 'package:login/widgets/textFields.dart';

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
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  initialCameraPosition: _initialLocation),

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
                        locationCallback: (String value) {
                          setState(() {
                            _startAddress = value;
                          });
                        },
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
                            delegate: PlacesListSearch(destinationAddressController),
                          );
                        },
                        prefixIcon: Icon(
                          Icons.flag,
                          color: Colors.orange,
                        ),
                        controller: destinationAddressController,
                        locationCallback: (String value) {
                          setState(
                            () {
                              _destinationAddress = value;
                            },
                          );
                        },
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
}

