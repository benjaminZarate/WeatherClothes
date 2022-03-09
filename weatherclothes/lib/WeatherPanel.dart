import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weatherclothes/model/Weather.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class WeatherPanel extends StatefulWidget {
  const WeatherPanel({ Key? key }) : super(key: key);

  @override
  _WeatherPanelState createState() => _WeatherPanelState();
}

class _WeatherPanelState extends State<WeatherPanel> {

  double lat = 0;
  double lon = 0;

  Future<Weather> getLocation()async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      // if (!_serviceEnabled) {
      //   return;
      // }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      // if (_permissionGranted != PermissionStatus.granted) {
      //   return;
      // }
    }
    _locationData = await location.getLocation();
    lat = _locationData.latitude!;
    lon = _locationData.longitude!;
    var url = Uri.parse('http://api.weatherapi.com/v1/current.json?key=f2b367d7f09643298a632009220803&q=$lat,$lon&aqi=no');
    final response = await http.get(url); 
    Weather _weather;

    if(response.statusCode == 200){
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);
      _weather = Weather(
        jsonData["location"]["name"].toString(),
        jsonData["location"]["country"].toString(),
        "${jsonData["current"]["temp_c"].toString().split('.')[0]}ºC",
        jsonData["current"]["condition"]["text"].toString(),
        int.parse(jsonData["current"]["is_day"].toString())
      );
      return _weather;
    }else{
      throw Exception("response failed");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    double _radiusContainer = 35;
    return Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(_radiusContainer),
                  bottomRight: Radius.circular(_radiusContainer),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
                child: FutureBuilder(
                  future: getLocation(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          weatherImage(snapshot.data!),
                          const SizedBox(width: 60,),
                          cityInfo(snapshot.data!),
                        ]
                      ),
                    );
                  }else if(snapshot.hasError){
                      return Text("Error");
                  }
                  return Center(child: CircularProgressIndicator());
                },  
                ),
              );
        }
      }

  Widget weatherImage(Object data){
    Weather w = data as Weather;
    if(data.weather == "Partly cloudy"){
      if(data.isDay == 0){
        return const Image(image: AssetImage(
              "assets/cloudyNight.png"),
              width: 130,
              height: 130,);
      }else{
        return const Image(
          image: AssetImage("assets/cloudy.png"),
          width: 150,
          height: 150,);
      }
    }
    else if(data.weather == "Sunny" || data.weather == "Clear"){
      if(data.isDay == 0){
        return const Image(
          image: AssetImage("assets/night.png"),
          width: 150,
          height: 150,);
      }else{
        return const Image(
          image: AssetImage("assets/soleado.png"),
          width: 150,
          height: 150,);
      }
    }else if(data.weather == "Moderate rain" || data.weather == "Light rain"){
      return const Image(
          image: AssetImage("assets/rainy.png"),
          width: 150,
          height: 150,);
    }else if(data.weather == "Patchy rain possible"){
      return const Image(
          image: AssetImage("assets/cloudy.png"),
          width: 150,
          height: 150,);
    }
    else{
      return CircularProgressIndicator();    
    }
    }

  Widget cityInfo(Object _data){
    Weather w = _data as Weather;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${_data.city}, ${_data.country}", //city get from the API
        style: const TextStyle(
          fontSize: 15,
          ),
        ),
        Text(_data.temperature, //temperature get from the API
        style: const TextStyle(
          fontSize: 60,
          ),
        ),
      ],
    );
  }