import 'package:client/cubit/game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:client/model/player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        return PlayerInfoScreens(
            players: BlocProvider.of<GameCubit>(context)
                .game
                .players
                .values
                .toList());
      },
    );
  }
}

class PlayerInfoScreens extends StatelessWidget {
  final List<Player> players;
  final Key? key;

  PlayerInfoScreens({required this.players, this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Players'),
      ),
      body: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          return PlayerInfoExpansionTile(players[index], context);
        },
      ),
    );
  }
}

class PlayerInfoExpansionTile extends StatelessWidget {
  final Player player;
  final BuildContext context;

  PlayerInfoExpansionTile(this.player, this.context);

  @override
  Widget build(BuildContext context) {
    final isClientPlayer =
        player.id == BlocProvider.of<GameCubit>(context).clientPlayerId;
    final isActivePlayer =
        player.id == BlocProvider.of<GameCubit>(context).game.activePlayerId;

    return ExpansionTile(
      title: _buildTitle(
          isClientPlayer, isActivePlayer, player.displayName ?? 'N/A'),
      children: [
        _buildText('Money: ${player.money ?? 0}'),
        // TODO: Make clickable widget which shows all their properties
        _buildText('Properties: None'),
        _buildText(
            'Get Out Of Jail Free Cards: ${player.getOutOfJailFreeCards ?? 0}'),
        _buildText('Active: ${isActivePlayer ? 'Yes' : 'No'}'),
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
