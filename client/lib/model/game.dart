import 'dart:ui';

import 'package:flutter/material.dart';

import 'player.dart';
import 'tiles.dart';
import 'roll.dart';
import 'package:client/json_utils.dart';

class Game {
  Game()
      : tierColors = {},
        lastRoll = Roll(),
        players = {},
        tiles = {};

  String? monetaryUnitName;
  String? monetaryUnitSymbol;
  Map<int, Color> tierColors;
  PlayerId? activePlayerId;
  Roll lastRoll;
  Map<PlayerId, Player> players;
  Map<int, Tile> tiles;

  /// Method used to retrieve a player's location if they are a valid player.
  int? getPlayerLocation(PlayerId playerId) {
    return players[playerId]?.location;
  }

  /// Update game data to match provided JSON values.
  void applyJson(Json? json) {
    print('Applying JSON: \n${json}');
    if (json == null) return;
    monetaryUnitName = json['monetaryUnitName'] ?? monetaryUnitName;
    monetaryUnitSymbol = json['monetaryUnitSymbol'] ?? monetaryUnitSymbol;
    if (json['tierColors'] != null) {
      tierColors[0] = Color(int.parse(json['tierColors']['1'], radix: 16));
      tierColors[1] = Color(int.parse(json['tierColors']['2'], radix: 16));
      tierColors[2] = Color(int.parse(json['tierColors']['3'], radix: 16));
      tierColors[3] = Color(int.parse(json['tierColors']['4'], radix: 16));
      tierColors[4] = Color(int.parse(json['tierColors']['5'], radix: 16));
      tierColors[5] = Color(int.parse(json['tierColors']['6'], radix: 16));
      tierColors[6] = Color(int.parse(json['tierColors']['7'], radix: 16));
      tierColors[7] = Color(int.parse(json['tierColors']['8'], radix: 16));
    }

    if (json['activePlayerId'] != null) {
      if (json['activePlayerId'] != '') {
        // TODO: Remove on server-side
        activePlayerId = PlayerId(json['activePlayerId'] as String);
      }
    }

    // TODO: This is obsolete. Remove?
    // lastRoll = lastRoll..applyJson(json['lastRoll']);

    // Load and update players to make client/server agree.
    if (json['players'] != null) {
      // TODO: Find a more optimized way to do this
      // Clear out player information each time it is loaded.
      players.clear();
      for (Json player in json['players']) {
        final id = PlayerId(player['id']);
        if (players[id] != null) {
          players[id]!.applyJson(player);
          continue;
        }
        players[id] = Player(id: id)..applyJson(player);
      }
    }

    // Load and update tiles
    if (json['tiles'] != null) {
      for (Json tile in json['tiles']) {
        final id = tile['id'];
        // Updates if the tile already exists.
        if (tiles[id] != null) {
          tiles[id]!.applyJson(json);
          continue;
        }
        // Instantiates new tiles.
        switch (tile['type']) {
          case 'improvable':
            tiles[id] = ImprovableTile(id: id)..applyJson(tile);
            ImprovableTile improvable = tiles[id] as ImprovableTile;
            improvable.setTierColor(tierColors);
          case 'railroad':
            tiles[id] = RailroadTile(id: id)..applyJson(tile);
          case 'utility':
            tiles[id] = UtilityTile(id: id)..applyJson(tile);
          case 'chance':
            tiles[id] = ChanceTile(id: id)..applyJson(tile);
          case 'communityChest':
            tiles[id] = CommunityChestTile(id: id)..applyJson(tile);
          case 'tax':
            tiles[id] = TaxTile(id: id)..applyJson(tile);
          case 'go':
            tiles[id] = GoTile(id: id)..applyJson(tile);
          case 'jail':
            tiles[id] = JailTile(id: id)..applyJson(tile);
          case 'freeParking':
            tiles[id] = FreeParkingTile(id: id)..applyJson(tile);
          case 'goToJail':
            tiles[id] = GoToJailTile(id: id)..applyJson(tile);
        }
      }
    }
  }
}
