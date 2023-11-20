import 'package:client/cubit/game_cubit.dart';
import 'package:client/view/properties_display.dart';
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
      appBar: AppBar(
        title: const Text('Players'),
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

    return Column(
      children: [
        ExpansionTile(
          title: _buildTitle(
            isClientPlayer,
            isActivePlayer,
            widget.player.displayName ?? 'N/A',
          ),
          children: [
            _buildText('Location ID: ${widget.player.location ?? 0}'),
            _buildText('Money: ${widget.player.money ?? 0}'),
            _buildText(
                'Get Out Of Jail Free Cards: ${widget.player.getOutOfJailFreeCards ?? 0}'),
            _buildText('Active: ${isActivePlayer ? 'Yes' : 'No'}'),
            PropertyList(
              assets: widget.player.assets,
            )
          ],
        ),
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

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(text),
    );
  }
}
