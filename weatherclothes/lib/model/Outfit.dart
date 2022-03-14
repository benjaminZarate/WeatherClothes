import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'Outfit.g.dart';

@JsonSerializable()
class Outfit{
  List<String> photos = [];
  List<String> path;
  String thumbnail;
  String name;
  String tag = "sunny";
  
  Outfit({required this.photos,required this. thumbnail,required this.path, required this.name, required this.tag});

  factory Outfit.fromJson(Map<String, dynamic> json) => _$OutfitFromJson(json);
  Map<String, dynamic> toJson() => _$OutfitToJson(this);
}