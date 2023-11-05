import 'dart:collection';
// import 'dart:html';

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
  ImprovableTile({
    required super.id,
    this.title,
    this.tier,
    this.quarterTurns,
    this.price,
  });

  String? title;
  int? tier;
  int? quarterTurns;
  int? price;

  @override
  void withJson(Json json) {
    title = json['title'] ?? title;
    tier = json['tier'] ?? tier;
    quarterTurns = json['quarterTurns'] ?? quarterTurns;
    price = json['price'] ?? price;
  }

  @override
  Widget createWidget() {
    return Container(
      color: Colors.grey,
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(color: Colors.red),
          ),
          Flexible(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  child: Text(
                    title ?? "Placeholder title",
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text('Price: $price', textAlign: TextAlign.center),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RailroadTile extends Tile {
  RailroadTile({
    required super.id,
    this.title,
    this.quarterTurns,
    this.price,
    this.image,
  });

  String? title;
  int? quarterTurns;
  int? price;
  String? image;

  @override
  void withJson(Json json) {
    title = json['title'] ?? title;
    quarterTurns = json['quarterTurns'] ?? quarterTurns;
    price = json['price'] ?? price;
    image = json['image'] ?? image;
  }

  @override
  Widget createWidget() {
    return Container(
        color: Colors.grey,
        child: Column(children: [
          Expanded(
              child: Text(
            title ?? "Placeholder title",
            textAlign: TextAlign.center,
          )),
          // TODO image
          Flexible(
            flex: 0,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Price: $price', textAlign: TextAlign.center),
            ),
          )
        ]));
  }
}

class UtilityTile extends Tile {
  UtilityTile({
    required super.id,
    this.title,
    this.quarterTurns,
    this.price,
    this.image,
  });

  String? title;
  int? quarterTurns;
  int? price;
  String? image;

  @override
  void withJson(Json json) {
    title = json['title'] ?? title;
    quarterTurns = json['quarterTurns'] ?? quarterTurns;
    price = json['price'] ?? price;
    image = json['image'] ?? image;
  }

  @override
  Widget createWidget() {
    return Container(
        color: Colors.grey,
        child: Column(children: [
          Expanded(
              child: Text(
            title ?? "Placeholder title",
            textAlign: TextAlign.center,
          )),
          // TODO image
          Flexible(
            flex: 0,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Price: $price', textAlign: TextAlign.center),
            ),
          )
        ]));
  }
}

class ChanceTile extends Tile {
  ChanceTile({
    required super.id,
    this.title,
    this.image,
    this.quarterTurns,
  });

  String? title;
  String? image;
  int? quarterTurns;

  @override
  void withJson(Json json) {
    title = json['title'] ?? title;
    quarterTurns = json['quarterTurns'] ?? quarterTurns;
    image = json['image'] ?? image;
  }

  @override
  Widget createWidget() {
    return Container(
        color: Colors.grey,
        child: Column(children: [
          Expanded(
              child: Text(
            title ?? "Placeholder title",
            textAlign: TextAlign.center,
          )),
          // TODO image
        ]));
  }
}

class CommunityChestTile extends Tile {
  CommunityChestTile({
    required super.id,
    this.title,
    this.image,
    this.quarterTurns,
  });

  String? title;
  String? image;
  int? quarterTurns;

  @override
  void withJson(Json json) {
    title = json['title'] ?? title;
    quarterTurns = json['quarterTurns'] ?? quarterTurns;
    image = json['image'] ?? image;
  }

  @override
  Widget createWidget() {
    return Container(
        color: Colors.grey,
        child: Column(children: [
          Expanded(
              child: Text(
            title ?? "Placeholder title",
            textAlign: TextAlign.center,
          )),
          // TODO image
        ]));
  }
}

class TaxTile extends Tile {
  TaxTile({
    required super.id,
    this.title,
    this.image,
    this.payCommandText,
    this.quarterTurns,
  });

  String? title;
  String? image;
  String? payCommandText;
  int? quarterTurns;

  @override
  void withJson(Json json) {
    title = json['title'] ?? title;
    quarterTurns = json['quarterTurns'] ?? quarterTurns;
    image = json['image'] ?? image;
    payCommandText = json['payCommandText'] ?? payCommandText;
  }

  @override
  Widget createWidget() {
    return Container(
        color: Colors.grey,
        child: Column(children: [
          Expanded(
              child: Text(
            title ?? "Placeholder title",
            textAlign: TextAlign.center,
          )),
          Flexible(
            child: Text(
              payCommandText ?? "Placeholder price",
              textAlign: TextAlign.center,
            ),
          )
        ]));
  }
}

// CORNER TILES

class GoTile extends Tile {
  GoTile({
    required super.id,
    this.quarterTurns,
    this.upperText,
    this.goImage,
    this.arrowImage,
  });

  int? quarterTurns;
  String? upperText;
  String? goImage;
  String? arrowImage;

  @override
  void withJson(Json json) {
    quarterTurns = json['quarterTurns'] ?? quarterTurns;
    upperText = json['upperText'] ?? upperText;
    goImage = json['goImage'] ?? goImage;
    arrowImage = json['arrowImage'] ?? arrowImage;
  }

  @override
  Widget createWidget() {
    return const Placeholder();
  }
}

class JailTile extends Tile {
  JailTile({
    required super.id,
    this.quarterTurns,
    this.upperText,
    this.image,
    this.lowerText,
    this.visitingText,
  });

  int? quarterTurns;
  String? upperText;
  String? image;
  String? lowerText;
  String? visitingText;

  @override
  void withJson(Json json) {
    quarterTurns = json['quarterTurns'] ?? quarterTurns;
    upperText = json['upperText'] ?? upperText;
    lowerText = json['lowerText'] ?? lowerText;
    visitingText = json['visitingText'] ?? visitingText;
    image = json['image'] ?? image;
  }

  @override
  Widget createWidget() {
    return Container(
        color: Colors.grey,
        child: Column(children: [
          Expanded(
              child: Text(
            upperText ?? "Placeholder title",
            textAlign: TextAlign.center,
          )),
          Flexible(
            child: Text(
              lowerText ?? "Placeholder lower text",
              textAlign: TextAlign.center,
            ),
          ),
          Flexible(
            child: Text(
              visitingText ?? "Placeholder visiting text",
              textAlign: TextAlign.center,
            ),
            // TODO image
          )
        ]));
  }
}

class FreeParkingTile extends Tile {
  FreeParkingTile({
    required super.id,
    this.quarterTurns,
    this.upperText,
    this.image,
    this.lowerText,
  });

  int? quarterTurns;
  String? upperText;
  String? image;
  String? lowerText;

  @override
  void withJson(Json json) {
    quarterTurns = json['quarterTurns'] ?? quarterTurns;
    upperText = json['upperText'] ?? upperText;
    lowerText = json['lowerText'] ?? lowerText;
    image = json['image'] ?? image;
  }

  @override
  Widget createWidget() {
    return Container(
        color: Colors.grey,
        child: Column(children: [
          Expanded(
              child: Text(
            upperText ?? "Placeholder title",
            textAlign: TextAlign.center,
          )),
          Flexible(
            child: Text(
              lowerText ?? "Placeholder lower text",
              textAlign: TextAlign.center,
            ),
          ),
          // TODO image
        ]));
  }
}

class GoToJailTile extends Tile {
  GoToJailTile({
    required super.id,
    this.quarterTurns,
    this.upperText,
    this.image,
    this.lowerText,
  });

  int? quarterTurns;
  String? upperText;
  String? image;
  String? lowerText;

  @override
  void withJson(Json json) {
    quarterTurns = json['quarterTurns'] ?? quarterTurns;
    upperText = json['upperText'] ?? upperText;
    lowerText = json['lowerText'] ?? lowerText;
    image = json['image'] ?? image;
  }

  @override
  Widget createWidget() {
    return Container(
        color: Colors.grey,
        child: Column(children: [
          Expanded(
              child: Text(
            upperText ?? "Placeholder title",
            textAlign: TextAlign.center,
          )),
          Flexible(
            child: Text(
              lowerText ?? "Placeholder lower text",
              textAlign: TextAlign.center,
            ),
          ),
          // TODO image
        ]));
  }
}
