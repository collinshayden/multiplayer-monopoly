import 'dart:convert';

import 'package:client/model/game_data.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../json_utils.dart';

class EndpointService {
  /// Internal constructor which should only be called once by the class itself.
  EndpointService._internal() : server = http.Client();

  /// Factory constructor which returns the singleton.
  factory EndpointService() => _instance;

  // Instantiate singleton
  static final _instance = EndpointService._internal();

  final http.Client server;

  Future<Json> getGameData() async {
    final response = await server.get(
      Uri.parse('$API_URL/state'),
    );
    final status = jsonDecode(response.body);
    return status;
  }

  Future<Json> registerPlayer({required String displayName}) async {
    final response = await server.get(
      Uri.parse('$API_URL/register_player?display_name=$displayName'),
    );
    final status = jsonDecode(response.body);
    return status;
  }

  Future<Json> rollDice(String playerId) async {
    final response = await server.get(
      Uri.parse('$API_URL/roll_dice?player_id=$playerId'),
    );
    final status = jsonDecode(response.body);
    return status;
  }

  Future<Json> drawCard(String playerId, String cardType) async {
    assert(cardType == 'chance' || cardType == 'community_chest');
    final response = await server.get(
      Uri.parse('$API_URL/draw_card?player_id=$playerId?card_type=$cardType'),
    );
    final status = jsonDecode(response.body);
    return status;
  }

  Future<Json> buyProperty(String playerId, int tileId) async {
    assert(0 <= tileId && tileId <= 39);
    final response = await server.get(
      Uri.parse('$API_URL/buy_property?player_id=$playerId?tile_id=$tileId'),
    );
    final status = jsonDecode(response.body);
    return status;
  }

  Future<Json> setImprovements(
      String playerId, int tileId, int quantity) async {
    assert(0 <= tileId && tileId <= 39);
    final response = await server.get(
      Uri.parse(
          '$API_URL/set_improvements?player_id=$playerId?tile_id=$tileId?quantity=$quantity'),
    );
    final status = jsonDecode(response.body);
    return status;
  }

  Future<Json> setMortgage(String playerId, int tileId, bool mortgage) async {
    final response = await server.get(
      Uri.parse(
          '$API_URL/set_mortgage?player_id=$playerId?tile_id=$tileId?mortgage=$mortgage'),
    );
    final status = jsonDecode(response.body);
    return status;
  }

  Future<Json> getOutOfJail(String playerId, JailMethod jailMethod) async {
    String call = '$API_URL/get_out_of_jail?player_id=$playerId';
    switch (jailMethod) {
      case JailMethod.doubles:
        call += '?method=doubles';
      case JailMethod.money:
        call += '?method=money';
      case JailMethod.card:
        call += '?method=card';
    }
    final response = await server.get(
      Uri.parse(call),
    );
    final status = jsonDecode(response.body);
    return status;
  }

  Future<Json> endTurn(String playerId) async {
    final response = await server.get(
      Uri.parse('$API_URL/end_turn?player_id=$playerId'),
    );
    final status = jsonDecode(response.body);
    return status;
  }

  Future<Json> reset(String playerId) async {
    final response = await server.get(
      Uri.parse('$API_URL/reset?player_id=$playerId'),
    );
    final status = jsonDecode(response.body);
    return status;
  }
}

void main() async {
  var endpointService = EndpointService();
  Json registrationResult =
      await endpointService.registerPlayer(displayName: 'Jason');
  print(registrationResult);
}
