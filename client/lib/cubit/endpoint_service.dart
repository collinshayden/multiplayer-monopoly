import 'dart:convert';

import 'package:client/model/game_data.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class EndpointService {
  /// Internal constructor which should only be called once by the class itself.
  EndpointService._internal() : server = http.Client();

  /// Factory constructor which returns the singleton.
  factory EndpointService() => _instance;

  // Instantiate singleton
  static final _instance = EndpointService._internal();

  final http.Client server;

  Future<GameData> getGameData() async {
    final response =
        await server.get(Uri.parse('$REMOTE_HOST/$REMOTE_API_NAME'));
    final json = jsonDecode(response.body);
    return GameData.fromJson(json);
  }
}
