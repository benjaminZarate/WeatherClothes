import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'OutfitCard.dart';
import 'model/Outfit.dart';

class AllOutfits extends StatefulWidget {
  AllOutfits({ Key? key, required this.outfits }) : super(key: key);

  List<Outfit?> outfits;
  @override
  _AllOutfitsState createState() => _AllOutfitsState();
}

class _AllOutfitsState extends State<AllOutfits> {

  List<File> photos = [];

  void decodeFile(List<Outfit?> outfit) async{
    for (var _outfit in widget.outfits) {
      Uint8List photoInt = base64.decode(_outfit!.thumbnail);
      File newPhoto = await File(_outfit.path[0]).writeAsBytes(photoInt);
      photos.add(newPhoto);
    }
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    decodeFile(widget.outfits);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Outfits"),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 2)
          ), 
        itemBuilder: (context,index) =>
        GridTile(
          child: 
              photos.isNotEmpty ? outfitCard(photos[index]) : const CircularProgressIndicator(),
            ),
            scrollDirection: Axis.vertical,
            itemCount: widget.outfits.length,
        ),
    );
  }
}