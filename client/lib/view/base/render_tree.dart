import 'dart:ui';

class Node {
  Offset localOffset = Offset.zero;
  Size size = Size.zero;
}

class Handle {
  double? x;
  double? y;

  Handle(this.x, this.y);
  Handle.verticalAlignment(this.y);
  Handle.horizontalAlignment(this.x);
}

enum BoardSide {
  left,
  top,
  right,
  bottom,
}

class Board extends Node {
  final double tileInsetProportion = 0.133;

  Map<int, TileBase> tiles = {};

  void _createTiles() => null;
}

class TileBase extends Node {
  static double strokeWidth = 0.02;
  static const String monetaryUnit = '\$';
}

class SideTile extends TileBase {
  final BoardSide side;
  final String titleText;
  static double titleTextTopPadding = 0.1;

  SideTile(this.side, this.titleText);
}

class CornerTile extends TileBase {}

class BuyableTile extends SideTile {
  final int purchasePrice;
  static double purchasePriceBottomPadding = 0.1;

  BuyableTile(super.side, super.titleText, this.purchasePrice);
}

class ImprovableTile extends BuyableTile {
  double colorBarFractionalInset = 0.250;
  Color color;

  ImprovableTile(
    super.side,
    super.purchasePrice,
    super.titleText,
    this.color,
  );
}

class RailroadTile extends BuyableTile {
  final Image image;

  RailroadTile(
    super.side,
    super.purchasePrice,
    super.titleText,
    this.image,
  );
}

class TaxTile extends SideTile {
  final Image image;
  final int taxAmount;
  static double taxAmountBottomPadding = 0.1;

  TaxTile(
    super.side,
    super.titleText,
    this.image,
    this.taxAmount,
  );
}

class ChanceTile extends SideTile {
  final Image image;

  ChanceTile(
    super.side,
    super.titleText,
    this.image,
  );
}

class CommunityChestTile extends SideTile {
  final Image image;

  CommunityChestTile(
    super.side,
    super.titleText,
    this.image,
  );
}

class GoTile extends CornerTile {
  final String upperText;
  final Image goImage;
  final Image arrowImage;

  GoTile(
    this.upperText,
    this.goImage,
    this.arrowImage,
  );
}

class JailTile extends CornerTile {
  final String upperJailText;
  final Image image;
  final String lowerJailText;
  final String visitingText;

  JailTile(
    this.upperJailText,
    this.image,
    this.lowerJailText,
    this.visitingText,
  );
}

class FreeParkingTile extends CornerTile {
  final String upperText;
  final Image image;
  final String lowerText;

  FreeParkingTile(
    this.upperText,
    this.image,
    this.lowerText,
  );
}

class GoToJailTile extends CornerTile {
  final String upperText;
  final Image image;
  final String lowerText;

  GoToJailTile(
    this.upperText,
    this.image,
    this.lowerText,
  );
}

void main() {
  var board = Board();
}
