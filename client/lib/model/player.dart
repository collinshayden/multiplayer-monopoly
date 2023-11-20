import 'package:client/json_utils.dart';
import 'package:client/model/asset.dart';

/// Thin wrapper class used to specify a player-unique identifier.
class PlayerId {
  PlayerId(this.value);

  final String value;

  @override
  String toString() => value;

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

/// Data class for players constructed from JSON.
class Player {
  Player({required this.id});
  PlayerId id;
  String? displayName;
  int? money;
  int? location;
  int? getOutOfJailFreeCards;
  List<Map<String, dynamic>> assets = [];

  /// Apply JSON to this object.
  ///
  /// This function will update this object's fields based on input JSON.
  /// This will overwrite existing fields, and ignore any extra fields present
  /// in the [Json] object passed to it.
  void applyJson(Json json) {
    assert(json["id"] == id.value);
    displayName = json["displayName"] ?? displayName;
    money = json["money"] ?? money;
    location = json["location"] ?? location;
    getOutOfJailFreeCards =
        json["getOutOfJailFreeCards"] ?? getOutOfJailFreeCards;
    // Clear out existing assets
    // assets.clear();
    // // Add updated assets into the list of player assets
    for (Map<String, dynamic> assetJson in json["assets"]) {
      assets.add(assetJson);
    }
  }
}
