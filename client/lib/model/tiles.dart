import 'package:flutter/material.dart';
import 'package:client/json_utils.dart';

// TODO: Make build methods use context for gestures, cubit interactions, &c.

/// An abstract base class for modelling board tiles.
sealed class Tile {
  Tile({required this.id});

  /// A unique identifier for board tiles.
  ///
  /// This value should be in the range [0, 39] for this implementation of
  /// Monopoly.
  final int id;

  /// Whether this tile is positioned in one of the corners of the board.
  bool? isCorner;

  /// The number of clockwise, 90-degree turns which a tile.
  ///
  /// For this implementation, the side of the board betweeen "Go To Jail" and
  /// "Go" are considered to have 0 quarter turns as they are displayed upright
  /// by default.
  int? quarterTurns;

  /// Ensure all values necessary to build a widget have been set.
  ///
  /// This getter should be used for:
  /// 1. Null checks, and
  /// 2. Display information validation.
  ///
  /// Additionally, the [mustCallSuper] annotation requires that a subclass
  /// of [Tile] must call [Tile._canBuild] in addition to specifying its own
  /// build validation parameters. As a convention, this should occur
  /// immediately in the getter as follows:
  ///
  /// ```
  /// @override
  /// bool get _canBuild {
  ///   return super._canBuild &&
  ///     field1 != null &&
  ///     field2 != null;  // &c...
  /// }
  /// ```
  @mustCallSuper
  bool get _canBuild {
    return isCorner != null && quarterTurns != null;
  }

  static const boardTextStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 7,
    fontWeight: FontWeight.w600,
  );

  /// Update fields from given JSON data.
  ///
  /// If a key in [json] translates to a field in the [Tile], replace the
  /// field's value with the corresponding value from [json]. Note that the
  /// types of the income value from [json] and the field must match. If a key
  /// is present in [json] which doesn't correspond to a field in the [Tile], it
  /// should be ignored by this function.
  ///
  /// If a [Tile] subclass contains a field which itself has an [applyJson]
  /// method, this method should prefer to call it to uphold the recursive
  /// functionality which this method is intended to provide.
  ///
  /// Additionally, the [mustCallSuper] annotation requires that overrides made
  /// to this method must call to `super.applyJson(Json json)`. As a convention,
  /// this should occur at the start of the method.
  @mustCallSuper
  void applyJson(Json json) {
    isCorner = json['isCorner'] ?? isCorner;
    quarterTurns = json['quarterTurns'] ?? quarterTurns;
  }

  /// Produce a widget given the available display configuration.
  ///
  /// Implementations of this method must begin with the assertion that display
  /// configuration has been properly loaded such that the Widget can be built.
  /// It should look as follows:
  /// ```
  /// assert(_canBuild == true, 'AssertionError message...');
  /// ```
  ///
  /// Implementations of this method can assume that the incoming constraints
  /// have the following aspect ratios expressed as a ratio beteween width and
  /// height:
  /// - If [isCorner] is `true`: 1 / 1 (square),
  /// - If [isCorner] is `false`: 621 / 362 (approx. 1.715 / 1)
  Widget build(BuildContext context);
}

// SIDE TILES

class ImprovableTile extends Tile {
  ImprovableTile({required super.id});

  String? title;
  int? tier;
  int? price;
  Color? tierColor;
  bool? isMortgaged = false;

  @override
  void applyJson(Json json) {
    super.applyJson(json);
    title = json['title'] ?? title;
    tier = json['tier'] ?? tier;
    price = json['price'] ?? price;
    isMortgaged = json['isMortgaged'] ?? isMortgaged;
  }

  @override
  bool get _canBuild {
    return super._canBuild &&
        title != null &&
        title!.isNotEmpty &&
        tierColor != null &&
        price != null &&
        isMortgaged != null;
  }

  @override
  Widget build(BuildContext context) {
    assert(
      _canBuild,
      'The parameters for this tile have not been fully defined for $runtimeType',
    );
    return RotatedBox(
      quarterTurns: quarterTurns ?? 0,
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(color: tierColor),
          ),
          Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  title ?? 'Placeholder title',
                  textAlign: TextAlign.center,
                  style: Tile.boardTextStyle,
                ),
                Text(
                  'Price: \$$price',
                  textAlign: TextAlign.center,
                  style: Tile.boardTextStyle,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void setTierColor(Map<int, Color> colorMap) {
    tierColor = colorMap[tier];
  }
}

class RailroadTile extends Tile {
  RailroadTile({required super.id});

  String? title;
  int? price;
  String? image;

  @override
  void applyJson(Json json) {
    super.applyJson(json);
    title = json['title'] ?? title;
    price = json['price'] ?? price;
    image = json['image'] ?? image;
  }

  @override
  bool get _canBuild {
    return super._canBuild &&
        title != null &&
        title!.isNotEmpty &&
        price != null &&
        image != null;
  }

  @override
  Widget build(BuildContext context) {
    assert(
      _canBuild,
      'The parameters for this tile have not been fully defined for $runtimeType',
    );
    return RotatedBox(
      quarterTurns: quarterTurns ?? 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            title ?? 'Placeholder title',
            textAlign: TextAlign.center,
            style: Tile.boardTextStyle,
          ),
          // TODO image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Image.asset('assets/images/$image'),
          ),
          Text(
            'Price: \$$price',
            textAlign: TextAlign.center,
            style: Tile.boardTextStyle,
          )
        ],
      ),
    );
  }
}

class UtilityTile extends Tile {
  UtilityTile({required super.id});

  String? title;
  int? price;
  String? image;

  @override
  void applyJson(Json json) {
    super.applyJson(json);
    title = json['title'] ?? title;
    price = json['price'] ?? price;
    image = json['image'] ?? image;
  }

  @override
  bool get _canBuild {
    return super._canBuild &&
        title != null &&
        title!.isNotEmpty &&
        price != null &&
        image != null;
  }

  @override
  Widget build(BuildContext context) {
    assert(
      _canBuild,
      'The parameters for this tile have not been fully defined for $runtimeType',
    );
    return RotatedBox(
      quarterTurns: quarterTurns ?? 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            title ?? 'Placeholder title',
            textAlign: TextAlign.center,
            style: Tile.boardTextStyle,
          ),
          // TODO: Add image
          Text(
            'Price: \$$price',
            textAlign: TextAlign.center,
            style: Tile.boardTextStyle,
          )
        ],
      ),
    );
  }
}

class ChanceTile extends Tile {
  ChanceTile({required super.id});

  String? title;
  String? image;

  @override
  void applyJson(Json json) {
    super.applyJson(json);
    title = json['title'] ?? title;
    image = json['image'] ?? image;
  }

  @override
  bool get _canBuild {
    return super._canBuild &&
        title != null &&
        title!.isNotEmpty &&
        image != null;
  }

  @override
  Widget build(BuildContext context) {
    assert(
      _canBuild,
      'The parameters for this tile have not been fully defined for $runtimeType',
    );
    return RotatedBox(
      quarterTurns: quarterTurns ?? 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            title ?? 'Placeholder title',
            textAlign: TextAlign.center,
            style: Tile.boardTextStyle,
          ),
          // TODO image
          Image.asset('assets/images/$image'),
        ],
      ),
    );
  }
}

class CommunityChestTile extends Tile {
  CommunityChestTile({required super.id});

  String? title;
  String? image;

  @override
  void applyJson(Json json) {
    super.applyJson(json);
    title = json['title'] ?? title;
    image = json['image'] ?? image;
  }

  @override
  bool get _canBuild {
    return super._canBuild &&
        title != null &&
        title!.isNotEmpty &&
        image != null;
  }

  @override
  Widget build(BuildContext context) {
    assert(
      _canBuild,
      'The parameters for this tile have not been fully defined for $runtimeType',
    );
    return RotatedBox(
      quarterTurns: quarterTurns ?? 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            title ?? 'Placeholder title',
            textAlign: TextAlign.center,
            style: Tile.boardTextStyle,
          ),
          // TODO image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Image.asset('assets/images/$image'),
          ),
        ],
      ),
    );
  }
}

class TaxTile extends Tile {
  TaxTile({required super.id});

  String? title;
  String? image;
  String? payCommandText;

  @override
  void applyJson(Json json) {
    super.applyJson(json);
    title = json['title'] ?? title;
    image = json['image'] ?? image;
    payCommandText = json['payCommandText'] ?? payCommandText;
  }

  @override
  bool get _canBuild {
    return super._canBuild &&
        title != null &&
        title!.isNotEmpty &&
        image != null &&
        payCommandText != null;
  }

  @override
  Widget build(BuildContext context) {
    assert(
      _canBuild,
      'The parameters for this tile have not been fully defined for $runtimeType',
    );
    return RotatedBox(
      quarterTurns: quarterTurns ?? 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            title ?? 'Placeholder title',
            textAlign: TextAlign.center,
            style: Tile.boardTextStyle,
          ),
          Image.asset('assets/images/$image'),
          Text(
            payCommandText ?? 'Placeholder price',
            textAlign: TextAlign.center,
            style: Tile.boardTextStyle,
          )
        ],
      ),
    );
  }
}

// CORNER TILES

class GoTile extends Tile {
  GoTile({required super.id});

  String? upperText;
  String? goImage;
  String? arrowImage;

  @override
  void applyJson(Json json) {
    super.applyJson(json);
    upperText = json['upperText'] ?? upperText;
    goImage = json['goImage'] ?? goImage;
    arrowImage = json['arrowImage'] ?? arrowImage;
  }

  @override
  bool get _canBuild {
    return super._canBuild &&
        upperText != null &&
        upperText!.isNotEmpty &&
        goImage != null &&
        arrowImage != null;
  }

  @override
  Widget build(BuildContext context) {
    assert(
      _canBuild,
      'The parameters for this tile have not been fully defined for $runtimeType',
    );
    return RotatedBox(
      quarterTurns: quarterTurns ?? 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            upperText ?? 'Placeholder title',
            textAlign: TextAlign.center,
            style: Tile.boardTextStyle,
          ),
          // TODO image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Image.asset('assets/images/$goImage'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Image.asset('assets/images/$arrowImage'),
          ),
        ],
      ),
    );
  }
}

class JailTile extends Tile {
  JailTile({required super.id});

  String? upperText;
  String? image;
  String? lowerText;
  String? visitingText;

  @override
  void applyJson(Json json) {
    super.applyJson(json);
    upperText = json['upperText'] ?? upperText;
    image = json['image'] ?? image;
    lowerText = json['lowerText'] ?? lowerText;
    visitingText = json['visitingText'] ?? visitingText;
  }

  @override
  bool get _canBuild {
    return super._canBuild &&
        upperText != null &&
        upperText!.isNotEmpty &&
        image != null &&
        lowerText != null &&
        lowerText!.isNotEmpty &&
        visitingText != null &&
        visitingText!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    assert(
      _canBuild,
      'The parameters for this tile have not been fully defined for $runtimeType',
    );
    return RotatedBox(
      quarterTurns: quarterTurns ?? 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            upperText ?? 'Placeholder title',
            textAlign: TextAlign.center,
            style: Tile.boardTextStyle,
          ),
          Text(
            lowerText ?? 'Placeholder lower text',
            textAlign: TextAlign.center,
            style: Tile.boardTextStyle,
          ),
          Text(
            visitingText ?? 'Placeholder visiting text',
            textAlign: TextAlign.center,
            style: Tile.boardTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Image.asset('assets/images/$image'),
          ),
        ],
      ),
    );
  }
}

class FreeParkingTile extends Tile {
  FreeParkingTile({required super.id});

  String? upperText;
  String? image;
  String? lowerText;

  @override
  void applyJson(Json json) {
    super.applyJson(json);
    upperText = json['upperText'] ?? upperText;
    image = json['image'] ?? image;
    lowerText = json['lowerText'] ?? lowerText;
  }

  @override
  bool get _canBuild {
    return super._canBuild &&
        upperText != null &&
        upperText!.isNotEmpty &&
        image != null &&
        lowerText != null &&
        lowerText!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: quarterTurns ?? 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            upperText ?? 'Placeholder title',
            textAlign: TextAlign.center,
            style: Tile.boardTextStyle,
          ),
          Text(
            lowerText ?? 'Placeholder lower text',
            textAlign: TextAlign.center,
            style: Tile.boardTextStyle,
          ),
          // TODO image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Image.asset('assets/images/$image'),
          ),
        ],
      ),
    );
  }
}

class GoToJailTile extends Tile {
  GoToJailTile({required super.id});

  String? upperText;
  String? image;
  String? lowerText;

  @override
  void applyJson(Json json) {
    super.applyJson(json);
    upperText = json['upperText'] ?? upperText;
    image = json['image'] ?? image;
    lowerText = json['lowerText'] ?? lowerText;
  }

  @override
  bool get _canBuild {
    return super._canBuild &&
        upperText != null &&
        upperText!.isNotEmpty &&
        image != null &&
        lowerText != null &&
        lowerText!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    assert(
      _canBuild,
      'The parameters for this tile have not been fully defined for $runtimeType',
    );
    return RotatedBox(
      quarterTurns: quarterTurns ?? 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            upperText ?? 'Placeholder title',
            textAlign: TextAlign.center,
            style: Tile.boardTextStyle,
          ),
          Text(
            lowerText ?? 'Placeholder lower text',
            textAlign: TextAlign.center,
            style: Tile.boardTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Image.asset('assets/images/$image'),
          ),
        ],
      ),
    );
  }
}
