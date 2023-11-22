import 'package:client/model/player.dart';
import 'package:flutter/material.dart';
import 'package:client/view/widgets.dart';
import 'package:client/view/game_screen/board.dart';
import 'package:client/view/game_screen/game_screen.dart';
import 'package:client/cubit/game_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaitScreen extends StatelessWidget {
  const WaitScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<GameCubit, GameState>(
              buildWhen: (previous, current) {
                return current is GameStateUpdateSuccess;
              },
              builder: (context, state) {
                if (state is GameStateUpdateSuccess) {
                  // return Text(BlocProvider.of<GameCubit>(context).game.players.length.toString());
                  List<Player> players = BlocProvider.of<GameCubit>(context)
                      .game
                      .players
                      .values
                      .toList();
                  // final isClientPlayer = widget.player.id == BlocProvider.of<GameCubit>(context).clientPlayerId;
                  if (players.length >= 2) {
                    return Column(
                      children: [
                        PlayerDisplay(players: players),
                        ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<GameCubit>(context).startGame();

                              Navigator.pushNamed(context, '/game');
                            },
                            child: Text("Start Game"))
                      ],
                    );
                  } else {
                    return PlayerDisplay(players: players);
                  }
                } else {
                  return Text("");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerDisplay extends StatelessWidget {
  final List<Player> players;

  PlayerDisplay({required this.players});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        players.length,
        (index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            players[index].displayName ?? "N/A",
            style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none
                // You can add more styles here as per your design
                ),
          ),
        ),
      ),
    );
  }
}
