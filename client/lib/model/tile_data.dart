import "package:json_annotation/json_annotation.dart";

part 'tile_data.g.dart';

@JsonSerializable(explicitToJson: true)
class TileData {
  int id;
  int owner;
  int improvements;

  TileData({
    required this.id,
    required this.owner,
    required this.improvements,
  });

  // auto generated factory constructor
  factory TileData.fromJson(Map<String, dynamic> json) =>
      _$TileDataFromJson(json);

  // auto generated factory constructor
  Map<String, dynamic> toJson() => _$TileDataToJson(this);

  void applyJson(Map<String, dynamic> json) {
    owner = json["owner"] ?? owner;
    improvements = json["improvements"] ?? improvements; // TODO += or = operator? Depends if json["improvements"] is sending a delta or updated value
  }
}
