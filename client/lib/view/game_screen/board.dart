import 'package:client/model/tiles.dart';
import 'package:client/view/game_screen/dice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/game_cubit.dart';
import 'tokens.dart';

/// Provides a background and container for the board.
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
            angle: 0,
            child: Stack(
              children: [
                Container(color: Color(int.parse('FFD5EFEA', radix: 16))),
                const TileLayout(),
                SizedBox.expand(
                  child: CustomPaint(
                    foregroundPainter: TileOutlinePainter(),
                  ),
                ),
                // TODO: Tokens here
                const Tokens(),
                // TODO: Dice here
                DisplayDice(),
                // TODO: Activity feed here
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// TILE LAYOUT

class TileLayout extends StatelessWidget {
  const TileLayout({super.key});

  /// Delegate function for building the board depending on game state.
  ///
  /// This function uses the tile ID's ([int]s) to tell the
  /// [_TileLayoutDelegate] how tiles can be identified in the enclosing
  /// [CustomMultiChildLayout]'s child list.
  Widget _buildBoard(BuildContext context, SuccessState state) {
    var tiles = state.game.tiles;
    return CustomMultiChildLayout(
      delegate: _TileLayoutDelegate(tileIds: tiles.keys.toList()),
      children: tiles.entries
          .map((e) => LayoutId(
                id: e.key,
                child: e.value.build(context),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        switch (state) {
          case LoadingState():
            return const Center(child: CircularProgressIndicator());
          case FailureState():
            return const Center(child: Text('Failed to load game action!'));
          case SuccessState():
            return _buildBoard(context, state);
          case _:
            return const Center(child: Text('Invalid state.'));
        }
      },
    );
  }
}

/// Performs dimensioning and positioning calculations for laying out tiles on
/// the board.
class _TileLayoutDelegate extends MultiChildLayoutDelegate {
  final List<int> tileIds;

  _TileLayoutDelegate({required this.tileIds});
  // Perform layout will be called when re-layout is needed.

  @override
  void performLayout(Size size) {
    // Determine all necessary dimensions.
    final boardSideLength = size.width;
    final double cornerTileSideLength = boardSideLength * 0.138;
    final double sideTileHeight = cornerTileSideLength;
    final double sideTileWidth =
        (boardSideLength - 2 * cornerTileSideLength) / 9;

    // Set initial position to the top-left corner of the bottom-left tile.
    Offset childPosition = Offset(0.0, size.height - cornerTileSideLength);

    for (final int id in tileIds) {
      if ([0, 10, 20, 30].contains(id)) /* Corner tiles */ {
        // Corner tiles
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
      } else /* Side tiles */ {
        var constraint =
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

  @override
  bool shouldRelayout(_TileLayoutDelegate oldDelegate) => true;
}

// TILE OUTLINES

class TileOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Compute dimensions and sizes
    final lineWidth = (1.4 / 502) * size.width;
    const lineColor = Colors.black;
    final innerSquareOffset = Offset(0.138 * size.width, 0.138 * size.height);
    final innerSquareSideLength = (1 - 2 * 0.138) * size.width;
    final sideTileWidth = (1 - 2 * 0.138) / 9 * size.width;
    final cornerTileSideLength = 0.138 * size.width;
    var outerLines = <List<Offset>>[];
    for (int i = 0; i < 10; i++) {
      // Left
      outerLines.add([
        Offset(cornerTileSideLength, cornerTileSideLength + i * sideTileWidth),
        Offset(0, cornerTileSideLength + i * sideTileWidth),
      ]);
      // Top
      outerLines.add([
        Offset(cornerTileSideLength + i * sideTileWidth, cornerTileSideLength),
        Offset(cornerTileSideLength + i * sideTileWidth, 0.0),
      ]);
      // Right
      outerLines.add([
        Offset(size.width - cornerTileSideLength,
            cornerTileSideLength + i * sideTileWidth),
        Offset(size.width, cornerTileSideLength + i * sideTileWidth),
      ]);
      // Bottom
      outerLines.add([
        Offset(cornerTileSideLength + i * sideTileWidth,
            size.height - cornerTileSideLength),
        Offset(cornerTileSideLength + i * sideTileWidth, size.height),
      ]);
    }

    // Create line paint style
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = lineColor
      ..strokeWidth = lineWidth;

    // Register paint commands
    canvas.drawRect(
      innerSquareOffset & Size(innerSquareSideLength, innerSquareSideLength),
      paint,
    );
    for (var pair in outerLines) {
      canvas.drawLine(pair[0], pair[1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
