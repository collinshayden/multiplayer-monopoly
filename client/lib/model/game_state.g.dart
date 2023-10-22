// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameState _$GameStateFromJson(Map<String, dynamic> json) => GameState(
      activePlayerId: json['activePlayerId'] as int,
      players: (json['players'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            int.parse(k), PlayerState.fromJson(e as Map<String, dynamic>)),
      ),
      lastRoll:
          (json['lastRoll'] as List<dynamic>).map((e) => e as int).toList(),
      tiles: (json['tiles'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            int.parse(k), TileState.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$GameStateToJson(GameState instance) => <String, dynamic>{
      'activePlayerId': instance.activePlayerId,
      'players':
          instance.players.map((k, e) => MapEntry(k.toString(), e.toJson())),
      'lastRoll': instance.lastRoll,
      'tiles': instance.tiles.map((k, e) => MapEntry(k.toString(), e.toJson())),
    };
