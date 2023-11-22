import 'package:client/cubit/game_cubit.dart';
import 'package:client/view/properties_display.dart';
import 'package:client/view/widgets.dart';
import 'package:flutter/material.dart';
import 'package:client/model/player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/cubit/game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/model/player.dart';

class PlayerDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        return PlayerInfoScreens(
          players:
              BlocProvider.of<GameCubit>(context).game.players.values.toList(),
        );
      },
    );
  }
}

class PlayerInfoScreens extends StatelessWidget {
  final List<Player> players;
  final Key? key;

  PlayerInfoScreens({
    required this.players,
    this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Players'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          return PlayerInfoExpansionTile(
            player: players[index],
          );
        },
      ),
    );
  }
}

class PlayerInfoExpansionTile extends StatefulWidget {
  final Player player;

  PlayerInfoExpansionTile({
    required this.player,
  });

  @override
  _PlayerInfoExpansionTileState createState() =>
      _PlayerInfoExpansionTileState();
}

class _PlayerInfoExpansionTileState extends State<PlayerInfoExpansionTile> {
  bool isPropertiesExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isClientPlayer =
        widget.player.id == BlocProvider.of<GameCubit>(context).clientPlayerId;
    final isActivePlayer = widget.player.id ==
        BlocProvider.of<GameCubit>(context).game.activePlayerId;
    final propertyList = PropertyList(player: widget.player);

    return Row(
      children: [
        // Player Information Column
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpansionTile(
                  title: _buildTitle(
                    isClientPlayer,
                    isActivePlayer,
                    widget.player.displayName ?? 'N/A',
                  ),
                  children: [
                    LeftRightJustifyTextWidget(
                        left: 'Location ID:',
                        right: '${widget.player.location ?? 0}'),
                    TextAmountWidget(
                        text: 'Money:', amount: widget.player.money ?? 0),
                    LeftRightJustifyTextWidget(
                        left: 'Doubles Streak',
                        right: '${widget.player.doublesStreak ?? 0}'),
                    LeftRightJustifyTextWidget(
                        left: 'Turns in Jail',
                        right: '${widget.player.turnsInJail ?? 0}'),
                    LeftRightJustifyTextWidget(
                        left: 'Get Out Of Jail Free Cards:',
                        right: '${widget.player.getOutOfJailFreeCards ?? 0}'),
                    LeftRightJustifyTextWidget(
                        left: 'Active:', right: isActivePlayer ? 'Yes' : 'No'),
                    // Commented out since properties aren't expanding to the side.
                    // HoverButton(
                    //   onTap: () {
                    //     setState(() {
                    //       isPropertiesExpanded = !isPropertiesExpanded;
                    //     });
                    //   },
                    //   label: isPropertiesExpanded
                    //       ? 'Hide Properties'
                    //       : "Show Properties",
                    //   child: IconButton(
                    //     icon: Icon(
                    //       isPropertiesExpanded
                    //           ? Icons.arrow_back
                    //           : Icons.arrow_forward,
                    //     ),
                    //     onPressed: null,
                    //   ),
                    // ),
                    propertyList
                  ],
                ),
              ],
            ),
          ),
        ),
        // Property Information Column
        // if (isPropertiesExpanded)
        //   Expanded(
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         PropertyList(
        //           assets: widget.player.assets,
        //         ),
        //       ],
        //     ),
        //   ),
      ],
    );
  }

  Widget _buildTitle(
      bool isClientPlayer, bool isActivePlayer, String displayName) {
    return Row(
      children: [
        if (isActivePlayer) ...[
          const Icon(Icons.arrow_forward, color: Colors.black),
          SizedBox(width: 4),
        ],
        if (isClientPlayer) ...[
          const Icon(Icons.star, color: Colors.amber),
          SizedBox(width: 4),
        ],
        Text(displayName),
      ],
    );
  }
}

class HoverButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  final String label;

  HoverButton({
    required this.onTap,
    required this.child,
    required this.label,
  });

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isHovered ? Colors.blue.withOpacity(0.2) : null,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.child,
              SizedBox(width: 8.0),
              Text(widget.label),
            ],
          ),
        ),
      ),
    );
  }

  void _handleHover(bool hover) {
    setState(() {
      isHovered = hover;
    });
  }
}
