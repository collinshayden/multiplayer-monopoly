import "package:json_annotation/json_annotation.dart";

part 'player_data.g.dart';

@JsonSerializable(explicitToJson: true)
class PlayerData {
  int id;
  String displayName;
  int money;
  int location;
  int getOutOfJailFreeCards;
  PlayerData(
      {required this.id,
      required this.displayName,
      required this.money,
      required this.location,
      required this.getOutOfJailFreeCards});

  // Generated factory constuctor.
  factory PlayerData.fromJson(Map<String, dynamic> json) =>
      _$PlayerDataFromJson(json);

  // Generated JSON output method.
  Map<String, dynamic> toJson() => _$PlayerDataToJson(this);

  // update playerData from json if relevant values are not null
  void applyJson(Map<String, dynamic> json) {
    id = json["id"] ?? id;
    displayName = json["displayName"] ?? displayName;
    money = json["money"] ?? money;
    location = json["location"] ?? location;
    getOutOfJailFreeCards = json["getOutOfJailFreeCards"] ?? getOutOfJailFreeCards;
  }
}
