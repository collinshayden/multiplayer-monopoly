import 'dart:ui';

import 'player.dart';
import 'tiles.dart';
import 'roll.dart';
import 'package:client/json_utils.dart';

class Game {
  /// Constructs an empty GameData object.
  Game()
      : tierColors = {},
        players = {},
        tiles = {};

  String? monetaryUnitName;
  String? monetaryUnitSymbol;
  Map<int, Color> tierColors;
  PlayerId? activePlayerId;
  Roll? lastRoll;
  Map<PlayerId, Player> players;
  Map<int, Tile> tiles;

  /// Update game data to match provided JSON values.
  void withJson(Json json) {
    monetaryUnitName = json['monetaryUnitName'] as String;
    monetaryUnitSymbol = json['monetaryUnitSymbol'] as String;
    tierColors[1] = Color(int.parse(json['1'], radix: 16));
    tierColors[2] = Color(int.parse(json['2'], radix: 16));
    tierColors[3] = Color(int.parse(json['3'], radix: 16));
    tierColors[4] = Color(int.parse(json['4'], radix: 16));
    tierColors[5] = Color(int.parse(json['5'], radix: 16));
    tierColors[6] = Color(int.parse(json['6'], radix: 16));
    tierColors[7] = Color(int.parse(json['7'], radix: 16));
    tierColors[8] = Color(int.parse(json['8'], radix: 16));
    activePlayerId = json['activePlayerId'] as PlayerId;
    lastRoll = Roll()..withJson(json['lastRoll']);

    for (Json player in json['players']) {
      final id = PlayerId(player['id'] as String);
      players[id] = Player()..withJson(player);
    }
    for (Json tile in json['tiles']) {
      final id = tile['id'] as int;
      // Updates if the tile already exists.
      if (tiles[id] != null) {
        tiles[id]!.withJson(json);
        continue;
      }
      // Instantiates new tiles.
      switch (tile['type']) {
        case 'improvable':
          tiles[id] = ImprovableTile(id: id)..withJson(tile);
        case 'railroad':
          tiles[id] = RailroadTile(id: id)..withJson(tile);
        case 'utility':
          tiles[id] = UtilityTile(id: id)..withJson(tile);
        case 'chance':
          tiles[id] = ChanceTile(id: id)..withJson(tile);
        case 'communityChest':
          tiles[id] = CommunityChestTile(id: id)..withJson(tile);
        case 'tax':
          tiles[id] = TaxTile(id: id)..withJson(tile);
        case 'go':
          tiles[id] = GoTile(id: id)..withJson(tile);
        case 'jail':
          tiles[id] = JailTile(id: id)..withJson(tile);
        case 'freeParking':
          tiles[id] = FreeParkingTile(id: id)..withJson(tile);
        case 'goToJail':
          tiles[id] = GoToJailTile(id: id)..withJson(tile);
      }
    }
  }
}
