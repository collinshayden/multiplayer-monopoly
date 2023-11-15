import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client/model/player.dart';
import 'package:client/constants.dart';
import 'package:client/json_utils.dart';

/// A service which provides access to the server's game API and outputs JSON.
class EndpointService {
  /// Internal constructor which should only be called once by the class itself.
  EndpointService._internal() : server = http.Client();

  /// Factory constructor which returns the singleton.
  factory EndpointService() => _instance;

  /// Instantiate singleton
  static final _instance = EndpointService._internal();

  /// Declare a lazily-loaded server connection
  late final http.Client server;

  Future<Json> fetchData() async {
    final response = await http.get(
      Uri.parse('$API_URL/data'),
    );
    final gameData = jsonDecode(response.body);
    print(gameData);
    return gameData;
  }

  void registerPlayer({required String displayName}) async {
    http.get(
      Uri.parse('$API_URL/register_player?display_name=$displayName'),
    );
  }

  void startGame({required PlayerId playerId}) async {
    http.get(
      Uri.parse('$API_URL/start_game?player_id=${playerId.value}'),
    );
  }

  void rollDice(PlayerId playerId) async {
    http.get(
      Uri.parse('$API_URL/roll_dice?player_id=${playerId.value}'),
    );
  }

  void drawCard(String playerId, String cardType) async {
    assert(cardType == 'chance' || cardType == 'community_chest');
    http.get(
      Uri.parse('$API_URL/draw_card?player_id=$playerId?card_type=$cardType'),
    );
  }

  void buyProperty(String playerId, int tileId) async {
    assert(0 <= tileId && tileId <= 39);
    http.get(
      Uri.parse('$API_URL/buy_property?player_id=$playerId?tile_id=$tileId'),
    );
  }

  void setImprovements(String playerId, int tileId, int quantity) async {
    assert(0 <= tileId && tileId <= 39);
    http.get(
      Uri.parse(
          '$API_URL/set_improvements?player_id=$playerId?tile_id=$tileId?quantity=$quantity'),
    );
  }

  /// Set the server-side
  void setMortgage(String playerId, int tileId, bool mortgage) async {
    http.get(
      Uri.parse(
          '$API_URL/set_mortgage?player_id=$playerId?tile_id=$tileId?mortgage=$mortgage'),
    );
  }

  void chooseJailReleaseMethod(String playerId, JailMethod jailMethod) async {
    String call = '$API_URL/choose_jail_release_method?player_id=$playerId';
    switch (jailMethod) {
      case JailMethod.doubles:
        call += '?method=doubles';
      case JailMethod.money:
        call += '?method=money';
      case JailMethod.card:
        call += '?method=card';
    }
    http.get(
      Uri.parse(call),
    );
  }

  void endTurn(String playerId) async {
    server.get(
      Uri.parse('$API_URL/end_turn?player_id=$playerId'),
    );
  }

  void reset({required PlayerId playerId}) async {
    server.get(
      Uri.parse('$API_URL/reset?player_id=${playerId.value}'),
    );
  }
}
