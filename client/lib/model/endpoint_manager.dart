import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

enum Action {
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

  Future<Map<String, dynamic>> send(Action action,
      Map<String, dynamic> parameters) async {
    var path;

    // Determine the endpoint path based on the enum
    switch (action) {
      case Action.resetGame:
        path = "./game/reset";
      case Action.registerPlayer:
        path = "./game/register_player";
      case Action.rollDice:
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

void main() async {
  var gameRequests = EndpointManager();
  print("Starting game!");
  var gameState = await gameRequests.receive();
  print(gameState);

  print("Registering player!");
  var serverResponse = await gameRequests.send(Action.registerPlayer,
      {"username": "jordan"});
  print(serverResponse);

  print("Resetting game!");
  serverResponse = await gameRequests.send(Action.resetGame, {});
  print(serverResponse);
}
