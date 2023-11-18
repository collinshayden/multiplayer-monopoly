import 'package:client/constants.dart';
import 'package:client/cubit/game_cubit.dart';
import 'package:client/model/player.dart';
import 'package:client/view/base/board.dart';
import 'package:client/view/dice.dart';
import 'package:client/view/player_info.dart';
import 'package:client/view/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MonopolyApp());
}

class MonopolyApp extends StatelessWidget {
  MonopolyApp({super.key});

  final backgroundColor = Color(int.parse('FF11202D', radix: 16));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        body: BlocProvider(
          create: (context) => GameCubit(),
          child: GameScreen(),
        ),
      ),
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

/// This widget contains the screen on which the game is played.
class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Load or reload local configuration whenever the game screen is rebuilt.
    BlocProvider.of<GameCubit>(context).loadLocalConfig();

    return const Stack(
      children: [
        Board(),
        AdminButtons(),
        DisplayDice(),
      ],
    );
  }
}

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

class AdminButtons extends StatelessWidget {
  const AdminButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.topRight,
          child: ExpandableTooltray(
            children: [
              ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<GameCubit>(context)
                        .endpointService
                        .reset(playerId: PlayerId("admin"));
                  },
                  child: const Text('Reset')),
              ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<GameCubit>(context)
                        .registerPlayer(displayName: "testUser");
                  },
                  child: const Text('Join')),
              ElevatedButton(
                  onPressed: () {
                    // BlocProvider.of<GameCubit>(context).updateGameData();

                    BlocProvider.of<GameCubit>(context)
                        .endpointService
                        .startGame(playerId: PlayerId("admin"));
                  },
                  child: const Text('Start Game')),
              ElevatedButton(
                  onPressed: () {
                    // BlocProvider.of<GameCubit>(context).updateGameData();
                    PlayerId activePlayerId =
                        BlocProvider.of<GameCubit>(context)
                            .game
                            .activePlayerId!;
                    BlocProvider.of<GameCubit>(context)
                        .rollDice(playerId: activePlayerId);
                  },
                  child: const Text('Roll')),
              ElevatedButton(
                  onPressed: () {
                    // BlocProvider.of<GameCubit>(context).updateGameData();
                    PlayerId activePlayerId =
                        BlocProvider.of<GameCubit>(context)
                            .game
                            .activePlayerId!;
                    BlocProvider.of<GameCubit>(context)
                        .endTurn(playerId: activePlayerId);
                  },
                  child: const Text('End Turn')),
              ElevatedButton(
                  onPressed: () async {
                    BlocProvider.of<GameCubit>(context).updateGameData();
                  },
                  child: const Text('Update State')),
              ElevatedButton(
                  onPressed: () async {
                    BlocProvider.of<GameCubit>(context).switchActivePlayerId();
                  },
                  child: const Text('Change to Active Player')),
              // Hardcoded as 0 for now. How can I get the tile ID the current player is on?

              ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<GameCubit>(context).buyProperty(0);
                  },
                  child: const Text('Buy Property')),
              MultiOptionWidget(
                  defaultText: "Select Mortgage",
                  options: const [
                    {'text': 'Mortgage', 'value': true},
                    {'text': 'Unmortgage', 'value': false},
                  ],
                  onPressed: (value) {
                    BlocProvider.of<GameCubit>(context).setMortgage(0, value);
                  }),
              MultiOptionWidget(
                  defaultText: "Select Jail method",
                  options: const [
                    {'text': 'Card', 'value': JailMethod.card},
                    {'text': 'Doubles', 'value': JailMethod.doubles},
                    {'text': 'Money', 'value': JailMethod.money},
                  ],
                  onPressed: (value) {
                    BlocProvider.of<GameCubit>(context).getOutOfJail(value);
                  }),
              NumberInputWidget(
                  buttonText: "Improvements",
                  onPressed: (value) {
                    BlocProvider.of<GameCubit>(context)
                        .setImprovements(0, value);
                  }),
            ],
          ),
        );
      },
    );
  }
}
