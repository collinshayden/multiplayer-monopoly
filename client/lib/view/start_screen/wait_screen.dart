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
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 100, bottom: 20),
            child: Text(
              'Welcome to Monopoly',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            'Created by Aidan Bonner, Jordan Bourdeau, Hayden Collins, and Alex Hall',
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.normal,
            ),
          ),
          Expanded(
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
                        List<Player> players =
                            BlocProvider.of<GameCubit>(context)
                                .game
                                .players
                                .values
                                .toList();
                        if (players.length >= 2) {
                          return Column(
                            children: [
                              PlayerDisplay(players: players),
                              ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<GameCubit>(context)
                                      .startGame();
                                  Navigator.pushNamed(context, '/game');
                                  BlocProvider.of<GameCubit>(context)
                                      .updateGameData();
                                },
                                child: Text("Start Game"),
                              ),
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
          ),
        ],
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
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Center(
            child: Text(
              'Connected Players',
              style: TextStyle(
                fontSize: 24, // Larger font size for the title
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Center(
            child: Column(
              children: players
                  .map((player) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          player.displayName ?? "N/A",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
