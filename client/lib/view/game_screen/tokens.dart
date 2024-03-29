import 'package:client/cubit/event_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

import 'package:client/model/player.dart';
import 'package:flutter/material.dart';
import 'package:client/cubit/game_cubit.dart';

// NOTES FOR AIDAN

/// Widgets you may want to look into (less any which you're already familiar with) include:
/// 1. [Align]
/// 2. [Alignment]
/// 3. [FractionalOffset]
/// 4. [Stack]
/// 5. [Image]
/// 6. [GameCubit]
///
/// ^ Ctrl + Click on any of those to pull up their docs/implementation.
///
/// Everything in this file will eventually end up in the widget tree of the
/// application, and thus it will be able to access the [GameCubit]. This is
/// done throughout the application using the following accessor:
/// `BlocProvider.of<GameCubit>(context)`. Note that this can only be done where
/// there is a `context` in scope, which means this must occur inside of the
/// [build] function, where it has [BuildContext] as a parameter passed in by
/// the framework at runtime.
///
/// This `BlocProvider.of<GameCubit>(context)` thing is the Cubit instance, and
/// thus any fields or methods defined in [GameCubit] can now be accessed. Note
/// that no fields should be altered directly, and that this should be done only
/// through method calls. I.e., fields are read only. I think you won't run into
/// any situations where you'd need to mutate the Cubit, but this is more of a
/// convention. This instance is how you can access information about the
/// player's whereabouts, and token type, etc.
///
/// I'm not sure if there's a way for players to pick a token, currently, so you
/// may want to simply skip retrieving a `tokenType` and use a default/random
/// image instead.
///
/// Just hit me up if you need any help/guidance. I won't be working tonight
/// much longer, but I'm happy to talk through things a bit if needed.
///
/// ~ AH

// IMPLEMENTATION

/// This class serves as a container for all of the [TokenManager]s in the
/// application's widget tree.
///
/// The incoming constraints (those passed down to it
/// by the parent widget) will be identical to the size of the board, and
/// therefore all positioning should be relative to the top-left of the board
/// and nothing should attempt to position a token outside of the board's size.
///
/// There is no way to access the size of the board from within the [build]
/// method, and thus relative sizing/positioning must be used for laying things
/// out (including tokens).
///
/// This class passes its constraints directly on to all [TokenManager]s which
/// it contains, and thus all immediate children will have the same exact size
/// as this class.
class Tokens extends StatelessWidget {
  const Tokens({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(aidan): This should be a stack containing [TokenManager]s.
    // TODO(aidan): Have token managers created for each player in the game (accessed through `BlocProvider.of...`)

    final players = BlocProvider.of<GameCubit>(context).game.players;
    final List<Widget> tokenManagers = players.values
        .map((v) => TokenManager(
              playerId: v.id,
              tileId: v.location ?? 0,
            ))
        .toList();
    return Stack(children: tokenManagers);
  }
}

/// Position a token within the given bounds.
class TokenManager extends StatelessWidget {
  TokenManager({
    super.key,
    required PlayerId this.playerId,
    required int this.tileId,
  });
  PlayerId playerId;
  int tileId;

  /// Compute the alignment which a token should have within this widget.
  ///
  /// Note that this widget's size is equal to the size of the board at any
  /// given moment in time (depending on screen size and window resizing per the
  /// user's device/preferences).
  ///
  /// TODO(aidan): Decide whether this function should return an [Alignment] or [FractionalOffset].
  ///
  /// This function is called from within the build method when building either
  /// an [Align] widget.
  Alignment computeTokenAlignment({
    required int tileId,
    inJail = false,
  }) {
    // TODO(aidan): Compute actual geometry here.
    // TODO(aidan): Compute a base offset corresponding to the target tile's top left corner or centre (depending on the method of alignment).
    // TODO(aidan): Compute additional offset to give a token a position within the tile itself.

    // Notes on board geometry:
    // Every side has 11 tiles, including 9 regular side tiles and 2 corners
    // The corner side length is 0.138 of the board size.
    // height is also 0.138
    // The side tile width (_along_ the side) is (1 - 2 * 0.138) / 9.
    // Railroad tiles fall on the dead centre of any side.
    // The Alignment's y-value for the railroad tile on the left side of the
    // board would be -((1 - 2 * 0.138) / 9) / 2), for example.
    double x = 0.00;
    double y = 0.00;
    // left/right sides have set x-coordinates
    // top/bottom have set y-coordinates
    // figure out which side the tile is on, set the right fixed coordinate
    // calculate the other coordinate for the specific tile
    // corners don't really matter
    // specific location of the tile on its side
    int sidePos = tileId % 10;
    // left side
    if (tileId < 10) {
      x = -1 + (0.138 * 0.75);
      y = 1 - (0.138 * 0.75);
      if (tileId != 0) {
        y -= (1.25 * 0.138) * sidePos;
      }
    } // top
    else if (tileId < 20) {
      x = -1 + (0.138 * 0.75);
      y = -1 + (0.138 * 0.75);
      if (tileId != 10) {
        x += (1.25 * 0.138) * sidePos;
      }
    } // right side
    else if (tileId < 30) {
      x = 1 - (0.138 * 0.75);
      y = -1 + (0.138 * 0.75);
      if (tileId != 20) {
        y += (1.25 * 0.138) * sidePos;
      }
    } // bottom
    else if (tileId < 40) {
      x = 1 - (0.138 * 0.75);
      y = 1 - (0.138 * 0.75);
      if (tileId != 30) {
        x -= (1.25 * 0.138) * sidePos;
      }
    }
    return Alignment(x, y);
  }

  @override
  Widget build(BuildContext context) {
    // TODO(aidan): Place an Align in the root of this subtree (where the Placeholder currently is).
    // TODO(aidan): Tell the Align how to align its children using the `alignment` parameter.
    // TODO(aidan): Tell it what to use as a child (i.e., the Token widget).
    Color color =
        BlocProvider.of<GameCubit>(context).game.players[playerId]!.color!;
    return BlocBuilder<EventCubit, EventState>(
        buildWhen: (previous, current) {
          return current is ShowMovePlayer;
        },
        builder: (context, state) => Align(
              alignment: computeTokenAlignment(
                tileId: BlocProvider.of<GameCubit>(context)
                        .game
                        .players[playerId]
                        ?.location ??
                    0,
              ),
              child: Token(color: color),
            ));
  }
}

class Token extends StatelessWidget {
  Token({super.key, required Color this.color});
  Color color;

  @override
  Widget build(BuildContext context) {
    // TODO(aidan): Return an image of a token
    return Icon(Icons.circle, color: color);
  }
}
