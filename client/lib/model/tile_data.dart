import "dart:ui";

import "package:client/view/base/tiles.dart";
import 'package:client/model/player_data.dart';
import "package:json_annotation/json_annotation.dart";

part 'tile_data.g.dart';

@JsonSerializable(explicitToJson: true)
class TileData {
  final int id;
  int? quarterTurns;
  int? color;
  int? price;
  int? payment;
  int? improvements;
  PlayerData? owner;
  String? title;
  String? upperText;
  String? lowerText;
  String? imagePath;
  String? imagePath2;
  String? visitingText;
  String? payCommandText;

  TileData({
    required this.id,
    this.quarterTurns,
    this.title,
    this.color,
    this.price,
    this.payment,
    this.owner,
    this.improvements,
    this.upperText,
    this.lowerText,
    this.imagePath,
    this.imagePath2,
    this.visitingText,
    this.payCommandText,
  });

  // auto generated factory constructor
  factory TileData.fromJson(Map<String, dynamic> json) =>
      _$TileDataFromJson(json);

  // auto generated factory constructor
  Map<String, dynamic> toJson() => _$TileDataToJson(this);

  void applyJson(Map<String, dynamic> json) {}
  // empty method

  @override
  external Type get runtimeType;
}

@JsonSerializable(explicitToJson: true)
class ImprovableTileData extends TileData {
  ImprovableTileData({
    required super.id,
    required super.quarterTurns,
    required super.owner,
    required super.improvements,
    required super.color,
    required super.price,
    required super.title,
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
  CornerTileData({
    required super.id,
    required super.quarterTurns,
    required super.upperText,
    required super.imagePath,
    super.lowerText,
    super.visitingText,
    super.imagePath2,
  });

  // auto generated factory constructor
  factory CornerTileData.fromJson(Map<String, dynamic> json) =>
      _$CornerTileDataFromJson(json);

  // auto generated factory constructor
  Map<String, dynamic> toJson() => _$CornerTileDataToJson(this);

  void applyJson(Map<String, dynamic> json) {
    upperText = json["upperText"] ?? upperText;
    imagePath = json["imagePath1"] ?? imagePath;
    imagePath2 = json["imagePath2"] ?? imagePath2;
  }
}

@JsonSerializable(explicitToJson: true)
class CommunityTileData extends TileData {
  CommunityTileData({
    required super.id,
    required super.quarterTurns,
    required super.title,
    required super.imagePath,
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
  ChanceTileData({
    required super.id,
    required super.quarterTurns,
    required super.title,
    required super.imagePath,
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
  TaxTileData({
    required super.id,
    required super.quarterTurns,
    required super.title,
    required super.imagePath,
    required super.payCommandText,
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
  RailroadTileData({
    required super.id,
    required super.quarterTurns,
    required super.title,
    required super.imagePath,
    required super.price,
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
  UtilityTileData({
    required super.id,
    required super.quarterTurns,
    required super.title,
    required super.imagePath,
    required super.price,
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
