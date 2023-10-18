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
      "properties": {
        "tile_a": [
          1,
          0
        ]
      },
      "jail_card": true
    },
    "2": {
      "money": 2500,
      "location": 5,
      "properties": {
        "tile_b": [
          2,
          0
        ],
        "tile_c": [
          0,
          1
        ]
      },
      "jail_card": false
    }
  }
''';

class PlayerData {
  PlayerData({required this.playerID, required this.displayName, this.money, this.location, this.properties, this.jail_card});
  int playerID;
  String displayName;
  int? money;
  int? location;
  Map<String, dynamic>? properties;
  int? jail_card;

} // end PlayerData

class PlayerManager {
  PlayerManager({required this.players});
  Map<int, PlayerData> players = {};

  void addPlayer(Map<String, dynamic> data) {
    players[data["player_id"]] = PlayerData(playerID: data["player_id"], displayName: data["displayName"]);
  }
  // TODO implement update method
  void setPlayerData(Map<String, dynamic> data) {
    PlayerData player = players[data["player_id"]]!; 
    player
    ..displayName = data["displayName"]
    ..money = data["money"]
    ..location = data["location"]
    ..jail_card = data["jail_card"];
    
  }
} // end PlayerManager


main() {
  final playerInfo = readJson(jsonData);
  PlayerManager manager = PlayerManager.fromJson(playerInfo);
}