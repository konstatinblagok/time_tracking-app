import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:timetrack/constants/constants.dart';
import 'package:timetrack/models/address_decoding.dart';
import 'package:timetrack/models/directions.dart';
import 'dart:convert' as convert ;
import 'package:timetrack/models/places_search.dart';


class PlacesService {
   Future<List<Results>> getAutocomplete(String search) async
  {
    var url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$search&key=$MAP_KEY';
    var response = await http.get(Uri.parse(url));
    final parsed = List<Map<String, dynamic>>.from(convert.jsonDecode(response.body)['results']);
    print('parsed');
    print(parsed);
    return parsed.map((place) => Results.fromJson(place)).toList();
  }


  Future<Directions> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    var url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$MAP_KEY';
    var response = await http.get(Uri.parse(url));
    print('directions');
    print(response.body);
    return Directions.fromMap(convert.jsonDecode(response.body));
  }

  Future<List<PlacesSearch>> getCityAutocomplete(String search) async
  {
    var url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${search}&types=(cities)&language=pt_BR&key=$MAP_KEY';
    print(url);
    var response = await http.get(Uri.parse(url));
    final parsed = List<Map<String, dynamic>>.from(convert.jsonDecode(response.body)['predictions']);
    print('cityparsed');
    print(parsed);
    return parsed.map((place) => PlacesSearch.fromJson(place)).toList();
  }

  Future<AddressDecoding> getLatLong(String address) async
  {
    var url="https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$MAP_KEY";
    // print(Uri.parse(url));
    final  response = await http.get(Uri.parse(url),   headers: _setHeaders());
    final parsed = convert.jsonDecode(response.body) as Map<String, dynamic>;
    // final parsedlist = List<Map<String, dynamic>>.from(convert.jsonDecode(response.body)['results']);
      return (AddressDecoding.fromJson(parsed));
  }


  _setHeaders() => {
    'content-type': 'application/json',
    'Accept': 'application/json'
  };
}