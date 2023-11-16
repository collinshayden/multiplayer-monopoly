import 'package:flutter/material.dart';
import 'package:client/model/player.dart'; // Make sure to import your Player class

class PlayerInfoScreens extends StatefulWidget {
  final List<Player> players;

  PlayerInfoScreens({required this.players});

  @override
  _PlayerInfoScreensState createState() => _PlayerInfoScreensState();
}

class _PlayerInfoScreensState extends State<PlayerInfoScreens> {
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
              itemCount: widget.players.length,
              itemBuilder: (context, index) {
                return _buildPlayerData(widget.players[index]);
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
}

Widget _buildText(String text, bool bold) {
  return Flexible(
    child: Text(
      textAlign: TextAlign.center,
      text,
      style: TextStyle(
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    ),
  );
}
