import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

enum Action {
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

  Future<String> send(Action action, Map<String, dynamic> parameters) async {
    var path;

    // Determine the endpoint path based on the enum
    switch (action) {
      case Action.registerPlayer:
        path = "./register_player";
      case Action.rollDice:
        path = "/roll_dice";
    }
    final uri = Uri.http(this.host, path, parameters);
    try {
      final request = await client.get(this.host, this.port, './');
      final response = await request.close();
      final data = await response.transform(utf8.decoder).join();
      return data;
    } finally {

    }
  }

  Future<Map<String, dynamic>> receive() async {
    /// Method which will be used in polling to receive the current state of
    /// the game via a GET request sent to the root of the server domain.
    try {
      final request = await client.get(this.host, this.port, './');
      final response = await request.close();
      final data = await response.transform(utf8.decoder).join();
      return jsonDecode(data);
    } finally {

    }
  }
}

void main() async {
  var gameRequests = EndpointManager();
  var gameState = await gameRequests.receive();
  print(gameState);
  var serverResponse = gameRequests.send(Action.registerPlayer,
      {"username": "jordan"});
  print(serverResponse);
  gameState = await gameRequests.receive();
  print(gameState);
}
