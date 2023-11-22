import 'package:client/json_utils.dart';

enum EventType {
  showPlayerJoin,
  promptStartGame,
  showStartGame,
  showStartTurn,
  showRoll,
  showPassGo,
  showRent,
  showTax,
  showMovePlayer,
  promptPurchase,
  showPurchase,
  showImprovement,
  showMortgage,
  promptEndTurn,
  showEndTurn,
  promptLiquidate,
  showLoser,
  showEndGame,
  showBankruptcy,
}

/// Lightweight wrapper class for events passed between the server and client.
///
/// This class utilises the [EventType] enumerated type to indicate the type of
/// event, and parameters specifying what the event is are stored as a [Json]
/// object `Map<String, dynamic>`.
class Event {
  Event.fromJson(Json json) {
    // Looks at the enum and decides what type to take on.
    for (var e in EventType.values) {
      if (e.name == json['type']) {
        type = e;
      }
    }
    json.remove('type');
    parameters = json;
  }

  EventType? type;
  late Json parameters;
}
