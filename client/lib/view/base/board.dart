import 'dart:math';

import 'package:flutter/material.dart';

class Board extends StatelessWidget {
  const Board({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Transform.rotate(
            // angle: pi / 2,
            angle: 0,
            child: Stack(children: [
              Container(color: Colors.red[100]),
              CustomLayout(),
            ]),
          ),
        ),
      ),
    );
  }
}

enum TileFormFactor {
  corner,
  side,
}

List<int> range(int size) => List.generate(size, (i) => i);

Color randomColor() {
  final random = Random();
  final red = 150; // Generates a random value between 0 and 255.
  final green = 170 + random.nextInt(86);
  final blue = 150;

  return Color.fromARGB(255, red, green, blue);
}

/// Lays out the children in a cascade, where the top corner of the next child
/// is a little above (`overlap`) the lower end corner of the previous child.
///
/// Will relayout if the text direction changes.
class _CustomLayoutDelegate extends MultiChildLayoutDelegate {
  final List<int> ids;

  _CustomLayoutDelegate({required this.ids});
  // Perform layout will be called when re-layout is needed.

  @override
  void performLayout(Size size) {
    // Set form factors
    final Map<int, TileFormFactor> _formFactors = {
      for (var id in ids)
        id: (<int>{0, 10, 20, 30}.contains(id)
            ? TileFormFactor.corner
            : TileFormFactor.side),
    };

    // Determine dimensions
    final boardSideLength = size.width;
    final double cornerTileSideLength = boardSideLength * 0.138;
    final double sideTileHeight = cornerTileSideLength;
    final double sideTileWidth =
        (boardSideLength - 2 * cornerTileSideLength) / 9;

    // Set initial position
    Offset childPosition = Offset(0.0, size.height - cornerTileSideLength);

    for (final int id in ids) {
      switch (_formFactors[id]!) {
        case TileFormFactor.corner:
          final constraint =
              BoxConstraints.tight(Size.square(cornerTileSideLength));
          layoutChild(id, constraint);

          positionChild(id, childPosition);
          if (id == 0) {
            childPosition += Offset(0.0, -sideTileWidth);
          } else if (id == 10) {
            childPosition += Offset(cornerTileSideLength, 0.0);
          } else if (id == 20) {
            childPosition += Offset(0.0, cornerTileSideLength);
          } else if (id == 30) {
            childPosition += Offset(-sideTileWidth, 0.0);
          }
        case TileFormFactor.side:
          BoxConstraints constraint =
              BoxConstraints.tight(Size(sideTileWidth, sideTileHeight));

// Swap w/h if tile is on left or right side
          if ((0 < id && id < 10) || (20 < id && id < 30)) {
            constraint =
                BoxConstraints.tight(Size(sideTileHeight, sideTileWidth));
          }

          layoutChild(id, constraint);
          positionChild(id, childPosition);
          if (0 < id && id < 9) {
            childPosition += Offset(0.0, -sideTileWidth);
          } else if (id == 9) {
            childPosition += Offset(0.0, -cornerTileSideLength);
          } else if (10 < id && id < 20) {
            childPosition += Offset(sideTileWidth, 0.0);
          } else if (20 < id && id < 30) {
            childPosition += Offset(0.0, sideTileWidth);
          } else if (30 < id && id < 40) {
            childPosition += Offset(-sideTileWidth, 0.0);
          }
      }
    }
  }

  // shouldRelayout is called to see if the delegate has changed and requires a
  // layout to occur. Should only return true if the delegate state itself
  // changes: changes in the CustomMultiChildLayout attributes will
  // automatically cause a relayout, like any other widget.
  @override
  bool shouldRelayout(_CustomLayoutDelegate oldDelegate) => true;
}

class CustomLayout extends StatelessWidget {
  final Map<int, PlaceholderTile> tiles = {};

  CustomLayout({super.key}) {
    tiles[0] = PlaceholderTile(angle: pi / 4);
    for (int id = 1; id < 10; id++) {
      tiles[id] = PlaceholderTile(angle: pi / 2);
    }
    tiles[10] = PlaceholderTile(angle: 3 * pi / 4);
    for (int id = 11; id < 20; id++) {
      tiles[id] = PlaceholderTile(angle: pi);
    }
    tiles[20] = PlaceholderTile(angle: -3 * pi / 4);
    for (int id = 21; id < 30; id++) {
      tiles[id] = PlaceholderTile(angle: -pi / 2);
    }
    tiles[30] = PlaceholderTile(angle: -pi / 4);
    for (int id = 31; id < 40; id++) {
      tiles[id] = PlaceholderTile(angle: 0);
    }
  }

  static final List<int> _ids = range(40);

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: _CustomLayoutDelegate(ids: _ids),
      children: <Widget>[
        // Create all of the colored boxes in the colors map.
        for (var id in _ids)
          // The "id" can be any Object, not just a String.
          LayoutId(
            id: id,
            child: GestureDetector(
              onTap: () => print('Tapped Tile $id'),
              child: Container(
                color: randomColor(),
                alignment: Alignment.center,
                child: Text('Tile $id'),
              ),
            ),
          ),
      ],
    );
  }
}

class PlaceholderTile extends StatelessWidget {
  final double angle;
  const PlaceholderTile({super.key, required this.angle});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Placeholder(),
    );
  }
}
