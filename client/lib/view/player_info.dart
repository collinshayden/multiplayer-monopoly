import 'package:client/cubit/game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:client/model/player.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Make sure to import your Player class

class PlayerDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlayerInfoScreens(
      key: UniqueKey(), // Add this line
      players: BlocProvider.of<GameCubit>(context).game.players.values.toList(),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildText("Name", true),
                _buildText("Money", true),
                _buildText("Properties", true),
                _buildText("Get Out Of Jail Free Cards", true),
                _buildText("Active", true),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            color: Colors.white,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: players.length,
              itemBuilder: (context, index) {
                return _buildPlayerData(players[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerData(Player player) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildText(player.displayName ?? 'N/A', false),
          _buildText('${player.money ?? 0}', false),
          // TODO: Make clickable widget which shows all their properties
          _buildText('None', false),
          _buildText('${player.getOutOfJailFreeCards ?? 0}', false),
          _buildText('Yes', false),
        ],
      ),
    );
  }

  Widget _buildText(String text, bool bold) {
    return Flexible(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
