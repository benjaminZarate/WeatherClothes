import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:weatherclothes/AddOutfit.dart';
import 'package:weatherclothes/AllOutfit.dart';
import 'package:weatherclothes/OutfitGrid.dart';
import 'package:weatherclothes/WeatherPanel.dart';

import 'package:weatherclothes/providers/OutfitProvider.dart';
import 'package:weatherclothes/providers/WeatherProvider.dart';

import 'model/Outfit.dart';
import 'model/Weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  
  String getWeather(String currentWeather){
    return currentWeather;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => OutfitProvider(),
        ),
        ChangeNotifierProvider(
          create: ((context) => WeatherProvider()),
        ),
      ],
      child: MaterialApp(
        title: 'Weather Clothes',
        theme: ThemeData(
          primarySwatch: Colors.yellow
        ),
        home: const MyHomePage(title: 'Weather Clothes'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final double _sizedBoxHeight = 20;

  List<Outfit> outfitList = [];
  List<Outfit> displayOutfit = [];
  List<File> photos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: GestureDetector(
          child: Icon(Icons.dry_cleaning),
          onTap: (){
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => AllOutfits(outfits: outfitList)
                )
              );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            WeatherPanel(),
            SizedBox(height:_sizedBoxHeight),
            OutfitGrid()
          ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async{
          final data = await Navigator.push(
            context,MaterialPageRoute(
              builder: (context) => const AddOutfit()
              ),
            );
              setState(() {
                if(data == null) return;
                // decodeFile(data);
                // writeJson(data);
              });
              //decodeFile(data);
        },
      ),
    );
  }
}
