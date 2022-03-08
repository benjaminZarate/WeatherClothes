import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:weatherclothes/AddOutfit.dart';
import 'package:weatherclothes/OutfitCard.dart';

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
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(_radiusContainer),
                  bottomRight: Radius.circular(_radiusContainer),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Image(
                      image: AssetImage('assets/soleado.png'), //this need to change
                      width: 150,
                      height: 150,
                      ),
                      const SizedBox(width: 50,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Valdivia, Chile", //city get from the API
                          style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text("24ºC", //temperature get from the API
                          style: TextStyle(
                              fontSize: 60,
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
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
