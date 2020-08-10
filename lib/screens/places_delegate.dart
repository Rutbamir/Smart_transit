import 'package:Smart_transit/fetchers/fetcher.dart';
import 'package:flutter/material.dart';
import '../UiHelper.dart';

class PlacesListSearch extends SearchDelegate<List<double>> {
  final TextEditingController controller;
  UiHelper _uiHelper = UiHelper();
  double latitude;
  double longitude;
  PlacesListSearch(this.controller);

  buildPlaces() {
    return FutureBuilder(
        future: getplaces(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _uiHelper.getLoading();
          } else {
            List<Map> myplaces = snapshot.data;
            List<Map> filteredList = myplaces
                .where(
                  (p) => p['destination'].toLowerCase().startsWith(query),
                )
                .toList();
            if (query == null) {
              filteredList = myplaces;
            } else {
              filteredList = filteredList;
            }

            return filteredList.isEmpty
                ? Container(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    child: Center(
                      child: Image.asset(
                        'assets/empty.jpg',
                        width: 300,
                        height: 300,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          controller.text = filteredList[index]['destination'];
                          latitude = double.parse(filteredList[index]['lat']);
                          longitude = double.parse(filteredList[index]['long']);
                          print('LAT: $latitude');
                          print('LONG: $longitude');

                          Navigator.pop(context, [latitude, longitude]);
                        },
                        title: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filteredList[index]['destination'],
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      );
                    });
          }
        });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.deepOrangeAccent,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.deepOrangeAccent,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        query,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildPlaces();
  }
}
