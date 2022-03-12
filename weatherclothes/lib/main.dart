import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weatherclothes/AddOutfit.dart';
import 'package:weatherclothes/OutfitCard.dart';
import 'package:weatherclothes/WeatherPanel.dart';

import 'model/Outfit.dart';

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
  List<File> photos = [];

  late File _filePath;
  String _jsonString = "";

  final String kFileName = 'outfitJson.json';

  bool _fileExists = false;

  var outfitJson = [];

  @override
  void initState() {
    super.initState();
    readJson();
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
              writeJson(data);
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
            itemCount: outfitList.length,
        ),
    );
  }

  void decodeFile(Outfit outfit) async{
    print("decoding");
    Uint8List photoInt = base64.decode(outfit.thumbnail);
    File newPhoto = await File(outfit.path[0]).writeAsBytes(photoInt);
    photos.insert(0,newPhoto);
    setState(() {
      getThumbnail(outfit);
    });
  }

  void getThumbnail(Outfit outfit){
    this.outfitList.add(outfit);
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
    print(outfit.name);
    outfitJson.add(outfit.toJson());
    _jsonString = jsonEncode(outfitJson);
    _filePath.writeAsString(_jsonString);
  }

  void readJson() async {
    // Initialize _filePath
    _filePath = await _localFile;

    // 0. Check whether the _file exists
    _fileExists = await _filePath.exists();
    print('0. File exists? $_fileExists');

    // If the _file exists->read it: update initialized _json by what's in the _file
    if (_fileExists) {
      try {
        //1. Read _jsonString<String> from the _file.
        _jsonString = await _filePath.readAsString();
        print('1.(_readJson) _jsonString: $_jsonString');

        //2. Update initialized _json by converting _jsonString<String>->_json<Map>
        outfitJson = jsonDecode(_jsonString);
        print(outfitJson.length);
        for (var item in outfitJson) {
          
          List<String> paths = item["path"].cast<String>();
          List<String> photoList = item["photos"].cast<String>();

          /*for (var path in item["path"]) {
            paths.add(path.toString());
          }

          for (var photo in item["photos"]) {
            photoList.add(photo.toString());
          }*/

          Outfit newOutfit = Outfit(
            path: paths,
            photos: photoList,
            name: item["name"].toString(),
            thumbnail: item["thumbnail"].toString(),
            tag: item["tag"].toString());

          decodeFile(newOutfit);          
        }
        setState(() {
        });
        print('2.(_readJson) _json: $outfitJson \n - \n');
        
      } catch (e) {
        // Print exception errors
        print('Tried reading _file error: $e');
        // If encountering an error, return null
      }
    }
  }
}
