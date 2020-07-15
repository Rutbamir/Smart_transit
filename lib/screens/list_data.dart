class PlacesList {
  final String locality;
  final String district;

  PlacesList({this.locality, this.district});
}

List<PlacesList> loadPlaces() {
  var places = <PlacesList>[
    PlacesList(
      locality: 'Khanyar',
      district: 'Srinagar',
    ),
    PlacesList(
      locality: 'Munawarabad',
      district: 'Srinagar',
    ),
    PlacesList(
      locality: 'Batamaloo',
      district: 'Srinagar',
    ),
    PlacesList(
      locality: 'Lal Chowk',
      district: 'Srinagar',
    ),
    PlacesList(
      locality: 'Dalgate',
      district: 'Srinagar',
    ),
    PlacesList(
      locality: 'Sonwar',
      district: 'Srinagar',
    ),
    PlacesList(
      locality: 'Rainawari',
      district: 'Srinagar',
    ),
    PlacesList(
      locality: 'Raj Bagh',
      district: 'Srinagar',
    ),
    PlacesList(
      locality: 'Lal Bazar',
      district: 'Srinagar',
    ),
  ];
  return places;
}
