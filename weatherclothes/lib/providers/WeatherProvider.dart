import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weatherclothes/model/Outfit.dart';

import '../model/Weather.dart';
import 'package:http/http.dart' as http;

class WeatherProvider with ChangeNotifier{
  Weather? _weather;

  Weather? get weather{
    return _weather;
  }

  set weather(Weather? currentWeather){
    weather = currentWeather;
    notifyListeners();
  }

  Future<void> get getLocation async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }
    _locationData = await location.getLocation();
    double lat = _locationData.latitude!;
    double lon = _locationData.longitude!;
    var url = Uri.parse('http://api.weatherapi.com/v1/current.json?key=f2b367d7f09643298a632009220803&q=$lat,$lon&aqi=no');
    final response = await http.get(url); 
    
    if(response.statusCode == 200){
      String body = utf8.decode(response.bodyBytes);
      String currentWeather = "sunny";
      final jsonData = jsonDecode(body);

      switch (jsonData["current"]["condition"]["text"].toString().toLowerCase()) {
        case "light rain":
          currentWeather = "rainy";
          break;
        
        case "moderate rain":
          currentWeather = "rainy";
          break;
        
        case "patchy rain possible":
          currentWeather = "cloudy";
          break;
        
        case "partly cloudy":
          currentWeather = "cloudy";
          break;

        case "fog":
          currentWeather = "cloudy";
          break;
        
        case "overcast":
          currentWeather = "cloudy";
          break;
        
        case "sunny":
          currentWeather = "sunny";
          break;

        case "clear":
          currentWeather = "sunny";
          break;
        
        default:
          currentWeather = "sunny";
          break;
        
      }
      weather = Weather(
        jsonData["location"]["name"].toString(),
        jsonData["location"]["country"].toString(),
        "${jsonData["current"]["temp_c"].toString().split('.')[0]}ºC",
        currentWeather,
        jsonData["current"]["condition"]["text"].toString().toLowerCase(),
        int.parse(jsonData["current"]["is_day"].toString())
      );
      notifyListeners();
    }else{
      throw Exception("response failed");
    }
  }
}