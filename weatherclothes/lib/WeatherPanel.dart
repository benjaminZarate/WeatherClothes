import 'package:flutter/material.dart';
import 'package:weatherclothes/model/Weather.dart';

class WeatherPanel extends StatefulWidget {
  WeatherPanel({ Key? key, required this.location}) : super(key: key);

  Future<Weather> location;

  @override
  _WeatherPanelState createState() => _WeatherPanelState();
}

class _WeatherPanelState extends State<WeatherPanel> {

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
                  future: widget.location,
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
                      return const Text("Error");
                  }
                  return const Center(child: CircularProgressIndicator());
                },  
                ),
              );
        }
      }

  Widget weatherImage(Object data){
    Weather w = data as Weather;
      if(data.weather == "partly cloudy"){
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
      else if(data.weather == "overcast"){
        return const Image(
            image: AssetImage("assets/cloudy.png"),
            width: 130,
            height: 130,);
      }
      else if(data.weather == "sunny" || data.weather == "clear"){
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
      }else if(data.weather == "moderate rain" || data.weather == "light rain"){
        return const Image(
            image: AssetImage("assets/rainy.png"),
            width: 130,
            height: 130,);
      }else if(data.weather == "patchy rain possible"){
        return const Image(
            image: AssetImage("assets/cloudy.png"),
            width: 130,
            height: 130,);
      }
      else{
        return const CircularProgressIndicator();    
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