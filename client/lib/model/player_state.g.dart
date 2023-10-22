// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerState _$PlayerStateFromJson(Map<String, dynamic> json) => PlayerState(
      playerID: json['playerID'] as int,
      displayName: json['displayName'] as String,
      money: json['money'] as int,
      location: json['location'] as int,
      jailCard: json['jailCard'] as int,
    );

Map<String, dynamic> _$PlayerStateToJson(PlayerState instance) =>
    <String, dynamic>{
      'playerID': instance.playerID,
      'displayName': instance.displayName,
      'money': instance.money,
      'location': instance.location,
      'jailCard': instance.jailCard,
    };
