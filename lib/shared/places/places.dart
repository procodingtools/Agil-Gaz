import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';

class Places{

  Position _position;
  String _cityName = null;

  Places(Position pos){
    _position = pos;
    _getCity();
  }


  Future<List<Place>> getPlace(String query) async {
    while (_cityName == null){}
    final encoded = Uri.encodeFull('$query $_cityName').toLowerCase();
    print(encoded);
    final response = await Dio().get("https://api.mapbox.com/geocoding/v5/mapbox.places/$encoded.json?access_token=pk.eyJ1IjoiZGphbWlpcnIiLCJhIjoiY2pmNDZmMm1lMWFhaDJ4cXgxaHppeWdpaSJ9.5ICqofr7rawa9uo2FyvsXg&country=TN");


    List<dynamic> list = json.decode(response.data)['features'];

    List<Place> places = List();

    for (Map<String, dynamic> map in list){
      String city, country, adr;
      double lat, lng;

      city = map['text'];
      for (Map<String, dynamic> context in map["context"])
        if (context["id"].toString().contains('country'))
          country = context['text'];
      adr = map['place_name'];

      lat = map["geometry"]["coordinates"][0];
      lng = map["geometry"]["coordinates"][1];

      print("city is  $adr");

      places.add(Place(city, country, lat, lng, adr));
    }

    return places;

  }

  void _getCity() async{
    final response = await Dio().get("https://api.mapbox.com/geocoding/v5/mapbox.places/${_position.longitude},${_position.latitude}.json?access_token=pk.eyJ1IjoiZGphbWlpcnIiLCJhIjoiY2pmNDZmMm1lMWFhaDJ4cXgxaHppeWdpaSJ9.5ICqofr7rawa9uo2FyvsXg");
    Map<String, dynamic> map = json.decode(response.data);

    for (Map<String, dynamic> m in map['features'][0]["context"])
      if (m["id"].toString().contains("region"))
        _cityName = m["text"];


  }

}





class Place{

  final String _city;
  final String _country;
  final String _address;
  final double _lat;
  final double _lng;

  Place(this._city, this._country, this._lat, this._lng, this._address);

  double get lng => _lng;

  String get address => _address;

  double get lat => _lat;

  String get country => _country;

  String get city => _city;

}