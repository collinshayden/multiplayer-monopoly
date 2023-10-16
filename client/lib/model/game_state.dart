/// Managing game state data
/// Author: Hayden Collins
/// Date: 10/15/2023

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



main() {
  final playerInfo = readJson(jsonData);
  Map<int, PlayerData> player_data = {}; 
  for (int i = 1; i < playerInfo.length; i++) {
    player_data[i] = PlayerData.fromJson(playerInfo["$i"]);
  }
  print("${player_data}");
  print('${playerInfo["1"]}');
}