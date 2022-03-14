import 'dart:io';

import 'package:flutter/material.dart';

import 'OutfitCard.dart';
import 'model/Outfit.dart';

class OutfitGrid extends StatefulWidget {
  OutfitGrid({ Key? key, required this.photos, required this.outfitList}) : super(key: key);

  List<File> photos;
  List<Outfit?> outfitList;

  @override
  _OutfitGridState createState() => _OutfitGridState();
}

class _OutfitGridState extends State<OutfitGrid> {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), 
        itemBuilder: (context,index) =>
        GridTile(
          child: 
              widget.photos.length >= 1 ? outfitCard(widget.photos[index]) : CircularProgressIndicator(),
            ),
            scrollDirection: Axis.vertical,
            itemCount: widget.outfitList.length,
        ),
    );
  }
}