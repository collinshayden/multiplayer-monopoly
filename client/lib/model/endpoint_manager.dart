/// Managing game state data
/// Author: Jordan Bourdeau
/// Date: 10/22/2023

import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

// enum of possible Actions to be passed in the send() method.
enum GameActions {
  resetGame,
  registerPlayer,
  rollDice,
  // buyProperty,
  // mortgageProperty,
  // unmortgageProperty,
  // drawChance,
  // drawCommunityChest,
  // getOutOfJail,
  // buildHouse,
  // sellHouse
}

class EndpointManager {
  /// Class handling HTTP requests with the Flask server.

  // Class variables
  final host = 'jbourde2.w3.uvm.edu';
  final port = 80;
  final client = HttpClient();

  Future<Map<String, dynamic>> send(
      GameActions action, Map<String, dynamic> parameters) async {
    // sends a request to the Flask server, specifying the type of action and parameters.
    //For resetGame and rollDice, no parameters are needed (pass empty map)
    var path;

    // Determine the endpoint path based on the enum
    switch (action) {
      case GameActions.resetGame:
        path = "./game/reset";
      case GameActions.registerPlayer:
        path = "./game/register_player";
      case GameActions.rollDice:
        path = "/game/roll_dice";
    }
    final uri = Uri.http(host, path, parameters);
    try {
      final request = await client.getUrl(uri);
      final response = await request.close();
      final data = await response.transform(utf8.decoder).join();
      return jsonDecode(data);
    } finally {}
  }

  Future<Map<String, dynamic>> receive() async {
    /// Method which will be used in polling to receive the current state of
    /// the game via a GET request sent to the root of the server domain.
    final uri = Uri.http(host, "./game");
    try {
      final request = await client.getUrl(uri);
      final response = await request.close();
      final data = await response.transform(utf8.decoder).join();
      return jsonDecode(data);
    } finally {}
  }
}


