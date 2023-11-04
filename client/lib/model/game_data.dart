import 'player_data.dart';
import 'tile_data.dart';
import 'roll_data.dart';
import 'package:client/json_utils.dart';

// part 'game_data.g.dart';

// @JsonSerializable(explicitToJson: true)
class GameData {
  /// Constructs an empty GameData object.
  GameData()
      : lastRoll = RollData(),
        players = {},
        tiles = {};

  int? activePlayerId;
  RollData? lastRoll;
  Map<int, PlayerData> players;
  Map<int, TileData> tiles;

  /// Deserialises JSON data received from the server to update this [GameData] instance's fields.
  void deserialiseAttributes(Json json) {
    // Game-scoped data
    activePlayerId = json['activePlayerId'] ?? activePlayerId;
    lastRoll!.updateJson(json['lastRoll'] ?? {});

    // Player-scoped data
    for (int i = 0; i < players.length; i++) {
      players[i]?.applyJson(json['players']['$i']);
    }

    // Tile-scoped data
    for (int i = 0; i < tiles.length; i++) {
      tiles[i]?.applyJson(json['tiles']['$i']);
    }
  }
}
