
import "../model/utils/endpoint.dart";

import "package:json_annotation/json_annotation.dart";

import 'player_state.dart';
import 'tile_state.dart';

part 'game_state.g.dart';


@JsonSerializable(explicitToJson: true)
class GameState {
  final int activePlayerId;
  final Map<int, PlayerState> players;
  final List<int> lastRoll;
  final Map<int, TileState> tiles;

  GameState({
    required this.activePlayerId,
    required this.players,
    required this.lastRoll,
    required this.tiles,
  });

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  Map<String, dynamic> toJson() => _$GameStateToJson(this);
}