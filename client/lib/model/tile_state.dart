import "package:json_annotation/json_annotation.dart";

part 'tile_state.g.dart';

@JsonSerializable(explicitToJson: true)
class TileState {
  int tileId;
  int owner;
  int improvements;

  TileState(
      {required this.tileId, required this.owner, required this.improvements});

  factory TileState.fromJson(Map<String, dynamic> json) =>
      _$TileStateFromJson(json);

  Map<String, dynamic> toJson() => _$TileStateToJson(this);
}
