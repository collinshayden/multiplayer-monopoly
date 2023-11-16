import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/game_cubit.dart';

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
                Container(color: Colors.red[100]),
                TileLayout(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// An enum used to specify the two possible shapes for a tile.
/// The two possible types are a square (for the corners) or a tall rectangle
/// (for the sides).
enum TileFormFactor {
  corner,
  side,
}

class TileLayout extends StatelessWidget {
  TileLayout({super.key});

  /// A list of integers used as unique identifiers for the tiles on the board.
  /// There are always exactly 40 such identifiers. The "GO" tile corresponds to
  /// `0` and subsequent
  final List<int> _ids = List.generate(40, (i) => i);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        switch (state) {
          case LocalConfigLoading():
            return const CircularProgressIndicator();
          case LocalConfigFailure():
            return const Placeholder(
              child: Text('Failed to load local configuration!'),
            );
          case LocalConfigSuccess():
            return _buildBoard(context, state as LocalConfigSuccess);
          case _:
            return const Placeholder(child: Text('Invalid state.'));
        }
      },
    );
  }

  Widget _buildBoard(BuildContext context, LocalConfigSuccess state) {
    return CustomMultiChildLayout(
      delegate: _CustomLayoutDelegate(ids: _ids),
      children: _buildLayoutChildren(context, state),
    );
  }

  List<Widget> _buildLayoutChildren(
      BuildContext context, LocalConfigSuccess state) {
    // print('Test!');
    final List<Widget> children = [];
    for (var tile in state.game.tiles.entries) {
      children
          .add(LayoutId(id: tile.key as int, child: tile.value.createWidget()));
    }
    return children;
  }
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
