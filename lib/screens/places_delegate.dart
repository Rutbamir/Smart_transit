import 'package:flutter/material.dart';
import 'list_data.dart';

class PlacesListSearch extends SearchDelegate<PlacesList> {
  final TextEditingController controller;
  PlacesListSearch(this.controller);
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
    final myList = query.isEmpty
        ? loadPlaces()
        : loadPlaces()
            .where(
              (p) => p.locality.toLowerCase().startsWith(query),
            )
            .toList();
    return myList.isEmpty
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
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final PlacesList listPlaces = myList[index];
              return ListTile(
                onTap: () {
                  controller.text =
                      "${listPlaces.locality}, ${listPlaces.district}";

                  close(context, null);
                },
                title: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        listPlaces.locality,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        listPlaces.district,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
