/// Tile State data class
/// Author: Hayden Collins
/// Created on 2023/10/22

import "package:json_annotation/json_annotation.dart";

part 'tile_state.g.dart';

@JsonSerializable(explicitToJson: true)
class TileState {
  int tileId;
  int owner;
  int improvements;

  TileState(
      {required this.tileId, required this.owner, required this.improvements});

  // auto generated factory constructor
  factory TileState.fromJson(Map<String, dynamic> json) =>
      _$TileStateFromJson(json);

  // auto generated factory constructor
  Map<String, dynamic> toJson() => _$TileStateToJson(this);
}
