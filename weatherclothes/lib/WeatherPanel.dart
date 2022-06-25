import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:weatherclothes/model/Weather.dart';

import 'package:weatherclothes/providers/WeatherProvider.dart';

class WeatherPanel extends StatelessWidget {
  const WeatherPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _radiusContainer = 35;

    final newWeather = Provider.of<WeatherProvider>(context);

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
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            newWeather.weather != null ? weatherImage(newWeather.weather!) : const CircularProgressIndicator(),
            const SizedBox(width: 60,),
            cityInfo(newWeather.weather),
            ]
          ),
        ),
      );
    }
  }

  Widget weatherImage(Weather? data){
    if(data == null) return const CircularProgressIndicator();
      if(data.apiWeather == "cloudy"){
        if(data.isDay == 0){
          return const Image(image: AssetImage(
                "assets/cloudyNight.png"),
                width: 130,
                height: 130,);
        }else{
          return const Image(
            image: AssetImage("assets/partlyCloudy.png"),
            width: 130,
            height: 130,);
        }
      }
      else if(data.apiWeather == "overcast"){
        return const Image(
            image: AssetImage("assets/cloudy.png"),
            width: 130,
            height: 130,);
      }
      else if(data.apiWeather == "sunny" || data.apiWeather == "clear"){
        if(data.isDay == 0){
          return const Image(
            image: AssetImage("assets/night.png"),
            width: 130,
            height: 130,);
        }else{
          return const Image(
            image: AssetImage("assets/soleado.png"),
            width: 130,
            height: 130,);
        }
      }else if(data.apiWeather == "moderate rain" || data.apiWeather == "light rain"){
        return const Image(
            image: AssetImage("assets/rainy.png"),
            width: 130,
            height: 130,);
      }else if(data.apiWeather == "patchy rain possible"){
        return const Image(
            image: AssetImage("assets/cloudy.png"),
            width: 130,
            height: 130,);
      }
      else{
        return const CircularProgressIndicator();    
      }
    }

  Widget cityInfo(Weather? _data){
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${_data?.city}, ${_data?.country}", //city get from the API
        style: const TextStyle(
          fontSize: 15,
          ),
        ),
        Text("${_data?.temperature}", //temperature get from the API
        style: const TextStyle(
          fontSize: 60,
          ),
        ),
      ],
    );
  }