import 'dart:convert';
import 'package:client/model/player.dart';
import 'package:http/http.dart' as http;
import 'package:client/constants.dart';
import 'package:client/json_utils.dart';
import 'package:client/model/player.dart';

/// A service which provides access to the server's game API and outputs JSON.
class EndpointService {
  /// Internal constructor which should only be called once by the class itself.
  EndpointService._internal() : server = http.Client();

  /// Factory constructor which returns the singleton.
  factory EndpointService() => _instance;

  // Instantiate singleton
  static final _instance = EndpointService._internal();

  final http.Client server;

  void startGame({required PlayerId playerId}) async {
    server.get(
      Uri.parse('$API_URL/start_game?player_id=${playerId.value}'),
    );
  }

  Future<Json> getGameData() async {
    final response = await server.get(
      Uri.parse('$API_URL/state?player_id=admin'),
    );
    final gameData = jsonDecode(response.body);
    // print(gameData);
    return gameData;
  }

  // Method which registers a player and returns their playerID
  Future<String> registerPlayer({required String displayName}) async {
    final response = await server.get(
      Uri.parse('$API_URL/register_player?display_name=$displayName'),
    );
    final playerData = jsonDecode(response.body);
    if (playerData["success"] ?? false) {
      return playerData["playerId"] ?? "";
    } else {
      return "";
    }
  }

  void rollDice(PlayerId playerId) async {
    server.get(
      Uri.parse('$API_URL/roll_dice?player_id=${playerId.value}'),
    );
  }

  void buyProperty(PlayerId playerId, int tileId) async {
    assert(0 <= tileId && tileId <= 39);
    server.get(
      Uri.parse(
          '$API_URL/buy_property?player_id=${playerId.value}?tile_id=$tileId'),
    );
  }

  void setImprovements(PlayerId playerId, int tileId, int quantity) async {
    assert(0 <= tileId && tileId <= 39);
    server.get(
      Uri.parse(
          '$API_URL/set_improvements?player_id=${playerId.value}?tile_id=$tileId?quantity=$quantity'),
    );
  }

  void setMortgage(PlayerId playerId, int tileId, bool mortgage) async {
    server.get(
      Uri.parse(
          '$API_URL/set_mortgage?player_id=${playerId.value}?tile_id=$tileId?mortgage=$mortgage'),
    );
  }

  void getOutOfJail(PlayerId playerId, JailMethod jailMethod) async {
    String call = '$API_URL/get_out_of_jail?player_id=${playerId.value}';
    switch (jailMethod) {
      case JailMethod.doubles:
        call += '?method=doubles';
      case JailMethod.money:
        call += '?method=money';
      case JailMethod.card:
        call += '?method=card';
    }
    server.get(
      Uri.parse(call),
    );
  }

  void endTurn(PlayerId playerId) async {
    server.get(
      Uri.parse('$API_URL/end_turn?player_id=${playerId.value}'),
    );
  }

  void reset({required PlayerId playerId}) async {
    server.get(
      Uri.parse('$API_URL/reset?player_id=${playerId.value}'),
    );
  }
}

// void main() async {
//   var endpointService = EndpointService();
//   Json registrationResult =
//       await endpointService.registerPlayer(displayName: 'Jason');
//   print(registrationResult);
// }
