/// PlayerState data class
/// Author: Hayden Collins
/// Created on 2023/10/22

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

  // auto generated factory constuctor. 
  factory PlayerState.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateFromJson(json);

  // auto generated toJson method. 
  Map<String, dynamic> toJson() => _$PlayerStateToJson(this);
} // end PlayerState