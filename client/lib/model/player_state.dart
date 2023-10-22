import "package:json_annotation/json_annotation.dart";

part 'player_state.g.dart';

@JsonSerializable(explicitToJson: true)
class PlayerState {
  int playerID;
  String displayName;
  int money;
  int location;
  int jailCard;
  PlayerState(
      {required this.playerID,
      required this.displayName,
      required this.money,
      required this.location,
      required this.jailCard});

  factory PlayerState.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerStateToJson(this);
} // end PlayerState