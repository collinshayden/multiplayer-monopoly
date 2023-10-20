/// Managing game state data
/// Author: Hayden Collins
/// Date: 10/15/2023

import "package:flutter/material.dart";

import "../model/utils/endpoint.dart";


// just defining as a string because I was having difficulty reading from json file
const jsonData = '''
   {
    "1": {
      "money": 1500,
      "location": 20,
      "jail_card": true
    },
    "2": {
      "money": 2500,
      "location": 5,
      "jail_card": false
    }
  }
''';

class PlayerData {
  PlayerData({required this.playerID, this.displayName, this.money, this.location, this.jailCard});
  int playerID;
  String? displayName;
  int? money;
  int? location;
  int? jailCard;

} // end PlayerData

class PlayerManager {
  PlayerManager({required this.players});
  Map<int, PlayerData> players = {};

  void addPlayer(Map<String, dynamic> data) {
    players[data["player_id"]] = PlayerData(playerID: data["player_id"]);
  }

  //TODO implement removePlayer method

  // overwrites player data from json
  void setPlayerData(Map<String, dynamic> data) {
    PlayerData player = players[data["player_id"]]!; 
    player
    ..displayName ??= data["displayName"]
    ..money ??= data["money"]
    ..location ??= data["location"]
    ..jailCard ??= data["jail_card"];
  }
} // end PlayerManager


main() {
  final playerInfo = readJson(jsonData);

}