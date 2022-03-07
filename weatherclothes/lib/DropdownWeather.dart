import 'package:flutter/material.dart';
import 'package:weatherclothes/AddOutfit.dart';

class DropdownWeather extends StatefulWidget {
  const DropdownWeather({ Key? key }) : super(key: key);

  @override
  _DropdownWeatherState createState() => _DropdownWeatherState();
}

class _DropdownWeatherState extends State<DropdownWeather> {

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Cloudy"),value: "cloudy"),
      DropdownMenuItem(child: Text("Sunny"),value: "sunny"),
      DropdownMenuItem(child: Text("Rainy"),value: "rainy"),
      DropdownMenuItem(child: Text("Warm"),value: "warm"),
    ];
    return menuItems;
  }
  String _selectedValue = "sunny";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        value: _selectedValue,
        items: dropdownItems,
        onChanged: (String? value){
          setState(() {
            _selectedValue = value!;
            
          });
        },
      ),
    );
  }
}