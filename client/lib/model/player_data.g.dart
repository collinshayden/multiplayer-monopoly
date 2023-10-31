// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerData _$PlayerDataFromJson(Map<String, dynamic> json) => PlayerData(
      id: json['id'] as int,
      displayName: json['displayName'] as String,
      money: json['money'] as int,
      location: json['location'] as int,
      getOutOfJailFreeCards: json['getOutOfJailFreeCards'] as int,
    );

Map<String, dynamic> _$PlayerDataToJson(PlayerData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'money': instance.money,
      'location': instance.location,
      'getOutOfJailFreeCards': instance.getOutOfJailFreeCards,
    };
