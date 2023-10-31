// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TileState _$TileStateFromJson(Map<String, dynamic> json) => TileState(
      tileId: json['tileId'] as int,
      owner: json['owner'] as int,
      improvements: json['improvements'] as int,
    );

Map<String, dynamic> _$TileStateToJson(TileState instance) => <String, dynamic>{
      'tileId': instance.tileId,
      'owner': instance.owner,
      'improvements': instance.improvements,
    };
