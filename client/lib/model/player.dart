import 'package:client/json_utils.dart';

class PlayerId {
  PlayerId(this.value);

  final int value;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType == PlayerId) {
      other = other as PlayerId;
      return value == other.value;
    }
    return false;
  }

  @override
  int get hashCode => value.hashCode;
}

class Player {
  Player();

  PlayerId? id;
  String? displayName;
  int? money;
  int? location;
  int? getOutOfJailFreeCards;

  void withJson(Json json) {
    assert(json["id"] == id);
    displayName = json["displayName"] ?? displayName;
    money = json["money"] ?? money;
    location = json["location"] ?? location;
    getOutOfJailFreeCards =
        json["getOutOfJailFreeCards"] ?? getOutOfJailFreeCards;
  }
}
