import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weatherclothes/AddOutfit.dart';
import 'package:weatherclothes/AllOutfit.dart';
import 'package:weatherclothes/OutfitGrid.dart';
import 'package:weatherclothes/WeatherPanel.dart';
import 'package:http/http.dart' as http;

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

  List<Outfit?> outfitList = [];
  List<Outfit> displayOutfit = [];
  List<File> photos = [];

  late File _filePath;
  String _jsonString = "";

  final String kFileName = 'outfitJson.json';

  bool _fileExists = false;

  var outfitJson = [];

  Weather? weatherObject;

  Future<Weather> getLocation()async {
    print("getting weather");
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

      final jsonData = jsonDecode(body);
      weatherObject = Weather(
        jsonData["location"]["name"].toString(),
        jsonData["location"]["country"].toString(),
        "${jsonData["current"]["temp_c"].toString().split('.')[0]}ºC",
        jsonData["current"]["condition"]["text"].toString().toLowerCase(),
        int.parse(jsonData["current"]["is_day"].toString())
      );
      return weatherObject!;
    }else{
      throw Exception("response failed");
    }
  }

  void decodeFile(Outfit outfit) async{
    Uint8List photoInt = base64.decode(outfit.thumbnail);
    File newPhoto = await File(outfit.path[0]).writeAsBytes(photoInt);
    photos.add(newPhoto);
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    readJson();
  }

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
            WeatherPanel(location: getLocation()),
            SizedBox(height:_sizedBoxHeight),
            OutfitGrid(photos: photos, outfitList: displayOutfit)
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
                writeJson(data);
              });
              //decodeFile(data);
        },
      ),
    );
  }

  void getThumbnail(Outfit outfit){
    outfitList.add(outfit);
    if(weatherObject == null) return;
    if(weatherObject!.weather == outfit.tag){
      setState(() {
        displayOutfit.add(outfit);
      });
    }
    print("getting thumbnail");
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$kFileName');
  }

  void writeJson(Outfit outfit){
    outfitJson.add(outfit.toJson());
    _jsonString = jsonEncode(outfitJson);
    _filePath.writeAsString(_jsonString);
    getThumbnail(outfit);
  }

  void readJson() async {
    // Initialize _filePath
    _filePath = await _localFile;

    // 0. Check whether the _file exists
    _fileExists = await _filePath.exists();

    // If the _file exists->read it: update initialized _json by what's in the _file
    if (_fileExists) {
      try {
        //1. Read _jsonString<String> from the _file.
        _jsonString = await _filePath.readAsString();

        //2. Update initialized _json by converting _jsonString<String>->_json<Map>
        outfitJson = jsonDecode(_jsonString);
        for (var item in outfitJson) {
          
          List<String> paths = item["path"].cast<String>();
          List<String> photoList = item["photos"].cast<String>();

          Outfit newOutfit = Outfit(
            path: paths,
            photos: photoList,
            name: item["name"].toString(),
            thumbnail: item["thumbnail"].toString(),
            tag: item["tag"].toString());       
          getThumbnail(newOutfit);
        }
      } catch (e) {
        
      }
    }
  }
}
