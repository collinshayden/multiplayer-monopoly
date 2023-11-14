import 'package:client/json_utils.dart';

enum EventType {
  startSession,
  enterQueue,
  updateQueue,
  toggleReadyPrompt,
  startGame,
  startTurn,
  showRoll,
  movePlayer,
  promptPurchase,
  showPurchase,
  showCardDraw,
  showImprovements,
  showMortgage,
  promptEndTurn,
  showLoser,
  showWinner,
  endGame,
}

/// Lightweight wrapper class for events passed between the server and client.
///
/// This class utilises the [EventType] enumerated type to indicate the type of
/// event, and parameters specifying what the event is are stored as a [Json]
/// object `Map<String, dynamic>`.
class Event {
  Event({required this.type, required this.parameters});

  EventType type;
  Json parameters;
}
