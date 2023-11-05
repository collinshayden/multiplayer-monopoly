import 'package:flutter/material.dart';
import 'package:client/json_utils.dart';

enum ImprovableTileTier {
  brown,
  lightBlue,
  magenta,
  orange,
  red,
  yellow,
  green,
  darkBlue
}

enum TileFormFactor {
  corner,
  side,
}

sealed class Tile {
  Tile({required this.id});

  final int id;

  void withJson(Json json);

  /// This function returns a widget whose configuration depends on fields of
  /// this [Tile].
  Widget createWidget();
}

// SIDE TILES

class ImprovableTile extends Tile {
  ImprovableTile({required super.id});

  String? title;

  @override
  void withJson(Json json) {
    title = json['title'] ?? title;
  }

  @override
  Widget createWidget() {
    return const Placeholder();
  }
}

class RailroadTile extends Tile {
  RailroadTile({required super.id});

  @override
  void withJson(Json json) {}

  @override
  Widget createWidget() {
    return const Placeholder();
  }
}

class UtilityTile extends Tile {
  UtilityTile({required super.id});

  @override
  void withJson(Json json) {}

  @override
  Widget createWidget() {
    return const Placeholder();
  }
}

class ChanceTile extends Tile {
  ChanceTile({required super.id});

  @override
  void withJson(Json json) {}

  @override
  Widget createWidget() {
    return const Placeholder();
  }
}

class CommunityChestTile extends Tile {
  CommunityChestTile({required super.id});

  @override
  void withJson(Json json) {}

  @override
  Widget createWidget() {
    return const Placeholder();
  }
}

class TaxTile extends Tile {
  TaxTile({required super.id});

  @override
  void withJson(Json json) {}

  @override
  Widget createWidget() {
    return const Placeholder();
  }
}

// CORNER TILES

class GoTile extends Tile {
  GoTile({required super.id});

  @override
  void withJson(Json json) {}

  @override
  Widget createWidget() {
    return const Placeholder();
  }
}

class JailTile extends Tile {
  JailTile({required super.id});

  @override
  void withJson(Json json) {}

  @override
  Widget createWidget() {
    return const Placeholder();
  }
}

class FreeParkingTile extends Tile {
  FreeParkingTile({required super.id});

  @override
  void withJson(Json json) {}

  @override
  Widget createWidget() {
    return const Placeholder();
  }
}

class GoToJailTile extends Tile {
  GoToJailTile({required super.id});

  @override
  void withJson(Json json) {}

  @override
  Widget createWidget() {
    return const Placeholder();
  }
}
