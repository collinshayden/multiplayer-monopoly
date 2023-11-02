import "dart:ui";

import "package:client/view/base/tiles.dart";
import "package:json_annotation/json_annotation.dart";

part 'tile_data.g.dart';

@JsonSerializable(explicitToJson: true)
class TileData {
  final int id;

  const TileData({
    required this.id,
  });

  // auto generated factory constructor
  factory TileData.fromJson(Map<String, dynamic> json) =>
      _$TileDataFromJson(json);

  // auto generated factory constructor
  Map<String, dynamic> toJson() => _$TileDataToJson(this);

  void applyJson(Map<String, dynamic> json) {

  }
    // empty method

}

@JsonSerializable(explicitToJson: true)
class ImprovableTileData extends TileData {
  int? owner;
  int improvements = 0;
  String title;

  ImprovableTileData({
    required super.id,
    required this.owner,
    required this.improvements,
    required this.title,
  });

  // auto generated factory constructor
  factory ImprovableTileData.fromJson(Map<String, dynamic> json) =>
      _$ImprovableTileDataFromJson(json);

  // auto generated factory constructor
  Map<String, dynamic> toJson() => _$ImprovableTileDataToJson(this);

  void applyJson(Map<String, dynamic> json) {
    owner = json["owner"] ?? owner;
    improvements = json["improvements"] ??
        improvements; // TODO += or = operator? Depends if json["improvements"] is sending a delta or updated value
  }
}

@JsonSerializable(explicitToJson: true)
class CornerTileData extends TileData {
  String upperText;
  String imagePath1;
  String? lowerText;
  String? visitingText;
  String? imagePath2;

  CornerTileData({
    required super.id,
    required this.upperText,
    required this.imagePath1,
    this.lowerText,
    this.visitingText,
    this.imagePath2,
  });

  // auto generated factory constructor
  factory CornerTileData.fromJson(Map<String, dynamic> json) =>
      _$CornerTileDataFromJson(json);

  // auto generated factory constructor
  Map<String, dynamic> toJson() => _$CornerTileDataToJson(this);

  void applyJson(Map<String, dynamic> json) {
    upperText = json["upperText"] ?? upperText;
    imagePath1 = json["imagePath1"] ?? imagePath1;
    imagePath2 = json["imagePath2"] ?? imagePath2;
  }
}

@JsonSerializable(explicitToJson: true)
class CommunityTileData extends TileData {
  String title;
  String imagePath;

  CommunityTileData({
    required super.id,
    required this.title,
    required this.imagePath,
  });

  // auto generated factory constructor
  factory CommunityTileData.fromJson(Map<String, dynamic> json) =>
      _$CommunityTileDataFromJson(json);

  // auto generated factory constructor
  Map<String, dynamic> toJson() => _$CommunityTileDataToJson(this);

  void applyJson(Map<String, dynamic> json) {
    title = json["title"] ?? title;
    imagePath = json["imagePath"] ?? imagePath;
  }
}

@JsonSerializable(explicitToJson: true)
class ChanceTileData extends TileData {
  String title;
  String imagePath;

  ChanceTileData({
    required super.id,
    required this.title,
    required this.imagePath,
  });

  // auto generated factory constructor
  factory ChanceTileData.fromJson(Map<String, dynamic> json) =>
      _$ChanceTileDataFromJson(json);

  // auto generated factory constructor
  Map<String, dynamic> toJson() => _$ChanceTileDataToJson(this);

  void applyJson(Map<String, dynamic> json) {
    title = json["title"] ?? title;
    imagePath = json["imagePath"] ?? imagePath;
  }
}

@JsonSerializable(explicitToJson: true)
class TaxTileData extends TileData {
  String title;
  String imagePath;
  String payCommandText;

  TaxTileData({
    required super.id,
    required this.title,
    required this.imagePath,
    required this.payCommandText,
  });

  // auto generated factory constructor
  factory TaxTileData.fromJson(Map<String, dynamic> json) =>
      _$TaxTileDataFromJson(json);

  // auto generated factory constructor
  Map<String, dynamic> toJson() => _$TaxTileDataToJson(this);

  void applyJson(Map<String, dynamic> json) {
    title = json["title"] ?? title;
    imagePath = json["imagePath"] ?? imagePath;
    payCommandText = json["payCommandText"] ?? payCommandText;
  }
}

@JsonSerializable(explicitToJson: true)
class RailroadTileData extends TileData {
  String title;
  String imagePath;

  RailroadTileData({
    required super.id,
    required this.title,
    required this.imagePath,
  });

  // auto generated factory constructor
  factory RailroadTileData.fromJson(Map<String, dynamic> json) =>
      _$RailroadTileDataFromJson(json);

  // auto generated factory constructor
  Map<String, dynamic> toJson() => _$RailroadTileDataToJson(this);

  void applyJson(Map<String, dynamic> json) {
    title = json["title"] ?? title;
    imagePath = json["imagePath"] ?? imagePath;
  }
}

@JsonSerializable(explicitToJson: true)
class UtilityTileData extends TileData {
  String title;
  String imagePath;

  UtilityTileData({
    required super.id,
    required this.title,
    required this.imagePath,
  });

  // auto generated factory constructor
  factory UtilityTileData.fromJson(Map<String, dynamic> json) =>
      _$UtilityTileDataFromJson(json);

  // auto generated factory constructor
  Map<String, dynamic> toJson() => _$UtilityTileDataToJson(this);

  void applyJson(Map<String, dynamic> json) {
    title = json["title"] ?? title;
    imagePath = json["imagePath"] ?? imagePath;
  }
}