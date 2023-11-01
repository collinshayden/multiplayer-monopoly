// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TileData _$TileDataFromJson(Map<String, dynamic> json) => TileData(
      id: json['id'] as int,
      owner: json['owner'] as int,
      improvements: json['improvements'] as int,
    );

Map<String, dynamic> _$TileDataToJson(TileData instance) => <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'improvements': instance.improvements,
    };
