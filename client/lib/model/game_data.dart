import 'player_data.dart';
import 'tile_data.dart';
import "package:json_annotation/json_annotation.dart";

part 'game_data.g.dart';

@JsonSerializable(explicitToJson: true)
class GameData {
  final int activePlayerId;
  final Map<int, PlayerData> players;
  final List<int> lastRoll;
  final Map<int, TileData> tiles;

  GameData({
    required this.activePlayerId,
    required this.players,
    required this.lastRoll,
    required this.tiles,
  });

  // default constuctor
  factory GameData.initial() =>
      GameData(activePlayerId: 0, players: {}, lastRoll: [], tiles: {});

  // References generated factory constructor.
  factory GameData.fromJson(Map<String, dynamic> json) =>
      _$GameDataFromJson(json);

  // References generated toJson output.
  Map<String, dynamic> toJson() => _$GameDataToJson(this);
}
