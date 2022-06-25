import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weatherclothes/model/Outfit.dart';

class OutfitProvider with ChangeNotifier{
  List<Outfit> _outfit = [];
  List<File> _photos = [];

  List<Outfit> get outfit{
    return _outfit;
  }

  set outfit(List<Outfit> newList){
    _outfit = newList;
    notifyListeners();
  }

  List<File> get photos{
    return _photos;
  }

  set photos (List<File> newList){
    _photos = newList;
    notifyListeners();
  }

  final String _fileName = 'outfitJson.json';

  late File _filePath;
  String _jsonString = "";

  bool _fileExists = false;
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  var outfitJson = [];

  Future<void> get readJson async {
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
         throw Exception(e);
      }
    }
  }

  void decodeFile(Outfit outfit) async{  
    Uint8List photoInt = base64.decode(outfit.thumbnail);
    File newPhoto = await File(outfit.path[0]).writeAsBytes(photoInt);
    photos.add(newPhoto); 
    notifyListeners();
  }

  void getThumbnail(Outfit outfit){
    _outfit.add(outfit);
    decodeFile(outfit);
    print("getting thumbnail");
  }
}