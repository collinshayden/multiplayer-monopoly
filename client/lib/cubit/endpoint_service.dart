import 'dart:convert';
import 'dart:async';
import 'dart:isolate';
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
  // static final _timerDuration = Duration(seconds: 1);

  /// Lazily-loaded object for creating a persistent connection with the server.
  late final http.Client server;

  /// Declare timer for making calls as an isolate
  // Timer? _timer;

  /// Retrieve a deserialised snapshot of the server's game object.
  ///
  /// This function calls the remote API's `state` endpoint.
  Future<Json> fetchData({required PlayerId playerId}) async {
    final response = await server.get(
      Uri.parse('$API_URL/state?player_id=${playerId.value}'),
    );
    final Json gameData = jsonDecode(response.body);
    return gameData;
  }

  Future<PlayerId> registerPlayer({required String displayName}) async {
    final response = await http.get(
      Uri.parse('$API_URL/register_player?display_name=$displayName'),
    );
    final Json body = jsonDecode(response.body);
    assert(body['event'] == 'registerPlayer');
    return PlayerId(body['playerId']);
  }

  Future<bool> startGame({required PlayerId playerId}) async {
    final response = await http.get(
      Uri.parse('$API_URL/start_game?player_id=$playerId'),
    );
    final Json body = jsonDecode(response.body);
    assert(body['event'] == 'startGame');
    return body['success'];
  }

  Future<bool> rollDice(PlayerId playerId) async {
    final response = await http.get(
      Uri.parse('$API_URL/roll_dice?player_id=$playerId'),
    );
    final Json body = jsonDecode(response.body);
    assert(body['event'] == 'rollDice');
    return body['success'];
  }

  Future<bool> drawCard(PlayerId playerId, String cardType) async {
    assert(cardType == 'chance' || cardType == 'community_chest');
    final response = await http.get(
      Uri.parse('$API_URL/draw_card?player_id=$playerId&card_type=$cardType'),
    );
    final Json body = jsonDecode(response.body);
    assert(body['event'] == 'drawCard');
    return body['success'];
  }

  Future<bool> buyProperty(PlayerId playerId, int tileId) async {
    assert(0 <= tileId && tileId <= 39);
    final response = await http.get(
      Uri.parse('$API_URL/buy_property?player_id=$playerId&tile_id=$tileId'),
    );
    final Json body = jsonDecode(response.body);
    assert(body['event'] == 'buyProperty');
    return body['success'];
  }

  Future<bool> setImprovements(
      PlayerId playerId, int tileId, int quantity) async {
    assert(0 <= tileId && tileId <= 39);
    final response = await http.get(
      Uri.parse(
          '$API_URL/set_improvements?player_id=${playerId.value}&tile_id=$tileId&quantity=$quantity'),
    );
    final Json body = jsonDecode(response.body);
    assert(body['event'] == 'setImprovement');
    return body['success'];
  }

  Future<bool> setMortgage(PlayerId playerId, int tileId, bool mortgage) async {
    final response = await http.get(
      Uri.parse(
          '$API_URL/set_mortgage?player_id=${playerId.value}&tile_id=$tileId&mortgage=$mortgage'),
    );
    final Json body = jsonDecode(response.body);
    assert(body['event'] == 'setMortgage');
    return body['success'];
  }

  Future<bool> getOutOfJail(PlayerId playerId, JailMethod jailMethod) async {
    String call = '$API_URL/get_out_of_jail?player_id=$playerId';
    switch (jailMethod) {
      case JailMethod.doubles:
        call += '&method=doubles';
      case JailMethod.money:
        call += '&method=money';
      case JailMethod.card:
        call += '&method=card';
    }
    final response = await http.get(
      Uri.parse(call),
    );
    final Json body = jsonDecode(response.body);
    assert(body['event'] == 'getOutOfJail');
    return body['success'];
  }

  Future<bool> endTurn(PlayerId playerId) async {
    final response = await http.get(
      Uri.parse('$API_URL/end_turn?player_id=$playerId'),
    );
    final Json body = jsonDecode(response.body);
    assert(body['event'] == 'endTurn');
    return body['success'];
  }

  Future<bool> reset({required PlayerId playerId}) async {
    final response = await http.get(
      Uri.parse('$API_URL/reset?player_id=$playerId'),
    );
    final Json body = jsonDecode(response.body);
    assert(body['event'] == 'reset');
    return body['success'];
  }
}
