import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:weatherclothes/AddOutfit.dart';
import 'package:weatherclothes/OutfitCard.dart';
import 'package:weatherclothes/WeatherPanel.dart';

import 'model/Outfit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Clothes',
      theme: ThemeData(
        primarySwatch: Colors.yellow
      ),
      home: const MyHomePage(title: 'Weather Clothes'),
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
  final double _radiusContainer = 35;
  final double _radiusCard = 20;
  final double _sizedBoxHeight = 20;

  List<Outfit?> outfit = [];
  List<File> photos = [];

  void decodeFile(Outfit outfit) async{
    Uint8List photoInt = base64.decode(outfit.thumbnail);
    print("thumbnail: ${outfit.path[0].toString()}");
    File newPhoto = await File(outfit.path[0]).writeAsBytes(photoInt);
    photos.insert(0,newPhoto);
    setState(() {
      getThumbnail(outfit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            WeatherPanel(),
            SizedBox(height:_sizedBoxHeight),
            __gridContent()
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
              decodeFile(data);
            });
        },
      ),
    );
  }

  Widget __gridContent(){
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), 
        itemBuilder: (context,index) =>
        GridTile(
          child: 
              outfitCard(photos[index]),
            ),
            scrollDirection: Axis.vertical,
            itemCount: outfit.length,
        ),
    );
  }

  void getThumbnail(Outfit outfit){
    this.outfit.add(outfit);
  }
}
