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

  Future<GameData> getGameData() async {
    final response = await server.get(Uri.parse('$API_URL/state'));
    final json = jsonDecode(response.body);
    return GameData.fromJson(json);
  }

  Future<Json> registerPlayer({required String displayName}) async {
    assert(!displayName.contains(' ')); // TODO: add more validation
    final response = await server.get(
      Uri.parse('$API_URL/register_player?username=$displayName'),
    );
    final json = jsonDecode(response.body);
    return json;
  }
}

void main() async {
  var endpointService = EndpointService();
  Json registrationResult =
      await endpointService.registerPlayer(displayName: 'Jason');
  print(registrationResult);
}
