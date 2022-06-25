import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:weatherclothes/model/Weather.dart';
import 'package:weatherclothes/providers/OutfitProvider.dart';
import 'package:weatherclothes/providers/WeatherProvider.dart';

import 'OutfitCard.dart';
import 'model/Outfit.dart';


class OutfitGrid extends StatelessWidget {
  
  OutfitGrid({Key? key}) : super(key: key);
  
  List<Outfit> outfits = [];
  List<File> photos = [];


  // void writeJson(Outfit outfit){
  //   outfitJson.add(outfit.toJson());
    
  //   _jsonString = jsonEncode(outfitJson);
  //   _filePath.writeAsString(_jsonString);
  //   getThumbnail(outfit);
  // }

  @override
  Widget build(BuildContext context) {

    final weatherProvider = Provider.of<WeatherProvider>(context);
    final outfitProvider = Provider.of<OutfitProvider>(context);

    context.read<OutfitProvider>().readJson;

    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), 
        itemBuilder: (context,index) =>
        GridTile(
          child: 
            outfitProvider.photos.isNotEmpty ? outfitCard(outfitProvider.photos[index]) : const CircularProgressIndicator(),
          ),
          scrollDirection: Axis.vertical,
          itemCount: outfitProvider.photos.length,
        ),
    );
  }
}