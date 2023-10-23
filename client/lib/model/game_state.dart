/// Game State data class
/// Author: Hayden Collins
/// Created on 2023/10/22

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

  // auto generated factory constuctor. 
  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  // auto generated toJson method. 
  Map<String, dynamic> toJson() => _$GameStateToJson(this);
}
