// import "package:json_annotation/json_annotation.dart";

// part 'player_data.g.dart';

// @JsonSerializable(explicitToJson: true)
class Player {
  String? id;
  String? displayName;
  int? money;
  int? location;
  int? getOutOfJailFreeCards;
  Player();

  // Generated factory constuctor.
  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  // Generated JSON output method.
  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  // update playerData from json if relevant values are not null
  void applyJson(Map<String, dynamic> json) {
    id = json["id"] ?? id;
    displayName = json["displayName"] ?? displayName;
    money = json["money"] ?? money;
    location = json["location"] ?? location;
    getOutOfJailFreeCards =
        json["getOutOfJailFreeCards"] ?? getOutOfJailFreeCards;
  }
}
