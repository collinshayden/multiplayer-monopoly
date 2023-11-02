// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TileData _$TileDataFromJson(Map<String, dynamic> json) => TileData(
      id: json['id'] as int,
    );

Map<String, dynamic> _$TileDataToJson(TileData instance) => <String, dynamic>{
      'id': instance.id,
    };

ImprovableTileData _$ImprovableTileDataFromJson(Map<String, dynamic> json) =>
    ImprovableTileData(
      id: json['id'] as int,
      owner: json['owner'] as int?,
      improvements: json['improvements'] as int,
      title: json['title'] as String,
    );

Map<String, dynamic> _$ImprovableTileDataToJson(ImprovableTileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'improvements': instance.improvements,
      'title': instance.title,
    };

CornerTileData _$CornerTileDataFromJson(Map<String, dynamic> json) =>
    CornerTileData(
      id: json['id'] as int,
      upperText: json['upperText'] as String,
      imagePath1: json['imagePath1'] as String,
      imagePath2: json['imagePath2'] as String?,
    );

Map<String, dynamic> _$CornerTileDataToJson(CornerTileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'upperText': instance.upperText,
      'imagePath1': instance.imagePath1,
      'imagePath2': instance.imagePath2,
    };

CommunityTileData _$CommunityTileDataFromJson(Map<String, dynamic> json) =>
    CommunityTileData(
      id: json['id'] as int,
      title: json['title'] as String,
      imagePath: json['imagePath'] as String,
    );

Map<String, dynamic> _$CommunityTileDataToJson(CommunityTileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imagePath': instance.imagePath,
    };

ChanceTileData _$ChanceTileDataFromJson(Map<String, dynamic> json) =>
    ChanceTileData(
      id: json['id'] as int,
      title: json['title'] as String,
      imagePath: json['imagePath'] as String,
    );

Map<String, dynamic> _$ChanceTileDataToJson(ChanceTileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imagePath': instance.imagePath,
    };

TaxTileData _$TaxTileDataFromJson(Map<String, dynamic> json) => TaxTileData(
      id: json['id'] as int,
      title: json['title'] as String,
      imagePath: json['imagePath'] as String,
      payCommandText: json['payCommandText'] as String,
    );

Map<String, dynamic> _$TaxTileDataToJson(TaxTileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imagePath': instance.imagePath,
      'payCommandText': instance.payCommandText,
    };
