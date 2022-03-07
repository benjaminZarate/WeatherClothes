// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Outfit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Outfit _$OutfitFromJson(Map<String, dynamic> json) => Outfit(
      photos:
          (json['photos'] as List<dynamic>).map((e) => e as String).toList(),
      thumbnail: json['thumbnail'] as String,
      path: (json['path'] as List<dynamic>).map((e) => e as String).toList(),
      name: json['name'] as String,
      tag: json['tag'] as String,
    );

Map<String, dynamic> _$OutfitToJson(Outfit instance) => <String, dynamic>{
      'photos': instance.photos,
      'path': instance.path,
      'thumbnail': instance.thumbnail,
      'name': instance.name,
      'tag': instance.tag,
    };
