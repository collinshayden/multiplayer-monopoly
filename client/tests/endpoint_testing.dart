/// Testing the endpoint interaction between server and client
/// Author: Hayden Collins
/// Date: 10/22/2023

import '../lib/model/endpoint_manager.dart';

// to run this isolated .dart file in terminal:
// navigate to client/tests/
// run "dart endpoint_testing.dart" in terminal. 
void main() async {
  print("Testing the server: sending requests and receiving data.");
  var gameRequests = EndpointManager();
  print("\nStarting game!");
  var gameState = await gameRequests.receive();
  print(gameState);

  print("\nRegistering player!");
  var serverResponse = await gameRequests
      .send(GameActions.registerPlayer, {"username": "jordan"});
  print(serverResponse);

  print("\nRequesting a dice roll!");
  serverResponse = await gameRequests.send(GameActions.rollDice, {});
  print(
      "\nDie 1: ${serverResponse['die_1']}. Die 2: ${serverResponse['die_2']}");

  print("\nResetting game!");
  serverResponse = await gameRequests.send(GameActions.resetGame, {});
  print(serverResponse);
}