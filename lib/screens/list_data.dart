class PlacesList {
  final String locality;
  final String district;

  PlacesList({this.locality, this.district});
}

List<PlacesList> loadPlaces() {
  var places = <PlacesList>[
    PlacesList(
      locality: 'Badu Bagh, Khanyar',
      district: 'Srinagar',
    ),
    PlacesList(
      locality: 'Munawarabad, Ikhwan Chowk',
      district: 'Srinagar',
    ),
    PlacesList(
      locality: 'IUST',
      district: 'naar-e-jahannum',
    ),
  ];
  return places;
}