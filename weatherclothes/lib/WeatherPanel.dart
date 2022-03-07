import 'dart:html';

import 'package:flutter/material.dart';

class WeatherPanel extends StatefulWidget {
  const WeatherPanel({ Key? key }) : super(key: key);

  @override
  _WeatherPanelState createState() => _WeatherPanelState();
}

class _WeatherPanelState extends State<WeatherPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
    );
  }
}