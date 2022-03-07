import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weatherclothes/DropdownWeather.dart';
import 'package:weatherclothes/model/Outfit.dart';
import "dart:io";

import 'OutfitCard.dart';

class AddOutfit 
extends StatefulWidget {
  
  const AddOutfit({ Key? key }) : super(key: key);

  @override
  _AddOutfitState createState() => _AddOutfitState();
}

class _AddOutfitState extends State<AddOutfit> {
  
  List<File?> _photos = [];
  final imagePicker = ImagePicker();

  late Outfit outfit;

  String name = "";
  String weather = "";

  Future getImage() async{
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _photos.insert(0,File(image!.path));
    });
  }

  void deleteImage(int index){
    setState(() {
      _photos.removeAt(index);
      print("deleted");
    });
  }

  void saveOutfit(){
    if(_photos.length == 0) return;
    List<String> _photosbytes = [];
    List<String> _photoPath = [];
    for(var i = 0; i < _photos.length; i++){
      if(_photos[i] == null) break;
      print("${_photos[i]} is in $i");
      List<int> photoBytes = _photos[i]!.readAsBytesSync();
      _photosbytes.add(base64.encode(photoBytes));
      _photoPath.add(_photos[i]!.path);
    }
    outfit = Outfit(photos: _photosbytes, thumbnail: _photosbytes[0],path: _photoPath, name: name, tag: weather);
    final outfitJson = outfit.toJson();
  }

  void readOutfit(){
    
  }

  void setName(String name){
    this.name = name;
  }

  void setWeather(String tag){
    weather = tag;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(_photos.length);
    _photos.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Outfit"),
      ),
      body: Column(
        children: [
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Outfit name',
              ),
            ),
          ),
          const DropdownWeather(),
          __gridContent()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save,color: Colors.black.withOpacity(0.7),),
        onPressed: (){
          saveOutfit();
          Navigator.pop(context,outfit);
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
          child: __conditionalGrid(index),
        ),
          scrollDirection: Axis.vertical,
          itemCount: _photos.isNotEmpty ? _photos.length : 1,
          shrinkWrap: true,
        ),
    );
  }

  Widget __addOutfit(){
    return InkWell(
      onTap: (() => getImage()),
      child: Container(
        width: 100,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 7,
              offset: const Offset(0,3),
            ),
          ]
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            Image.asset(
              'assets/plus.png',
              width: 60,
              height: 60,
              ),
              SizedBox(height: 10,),
            Text("Add a photo", 
              style: TextStyle(
                fontSize: 17,
              )
            )
          ],
        ),
      ),
    );
  }

  Widget __outfitThumbnail(int index){

    return GestureDetector(
      onLongPress: (){
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(1, 1, 1, 1),
          items: <PopupMenuEntry>[
          PopupMenuItem(
            value: index,
            child: Row(
              children: <Widget>[
                Icon(Icons.delete),
                Text("Delete"),
              ],
            ),
            onTap: () {
              deleteImage(index);
              print(_photos.length);
            },
          )
        ],
        );
      },
      child: Container(
        width: 100,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 7,
              offset: const Offset(0,3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.file(_photos[index]!),
        ),
      ),
    );
  }

  Widget __conditionalGrid(int index){
    if(index == _photos.length - 1 || _photos.isEmpty){
      print("add");
      return __addOutfit();
    }
    print("outfit");
    return __outfitThumbnail(index);
  }
}