import 'package:client/constants.dart';
import 'package:client/cubit/game_cubit.dart';
import 'package:client/model/player.dart';
import 'package:client/model/roll.dart';
import 'package:client/model/tiles.dart';
import 'package:client/view/base/board.dart';
import 'package:client/view/dice.dart';
import 'package:client/view/player_info.dart';
import 'package:client/view/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MonopolyApp(),
    ),
  );
}

class MonopolyApp extends StatefulWidget {
  const MonopolyApp({super.key});

  @override
  State<MonopolyApp> createState() => _MonopolyAppState();
}

class _MonopolyAppState extends State<MonopolyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: BlocProvider(
          create: (context) => GameCubit(),
          child: Stack(
            children: [
              const CubitTest(),
              const Board(),
              Center(
                child: SizedBox.fromSize(
                  size: const Size(100.0, 150.0),
                  child: const Column(
                    children: [
                      Align(),
                      // Roll(first: 1, second: 4).createWidget(),
                    ],
                  ),
                ),
              ),
              // const Spacer(),
              Align(alignment: Alignment.topLeft, child: PlayerDisplay()),
              const AdminButtons(),
              // ShowDice(),
            ],
          ),
        ),
      ),
    );
  }
}

class CubitTest extends StatelessWidget {
  const CubitTest({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        if (state is GameInitial) {
          return TextButton(
            onPressed: () {
              BlocProvider.of<GameCubit>(context).loadLocalConfig();
            },
            child: const Text('Load local config'),
          );
        }
        if (state is LocalConfigLoading) {
          return const CircularProgressIndicator();
        }
        return const Text('Loaded local config!');
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
                    BlocProvider.of<GameCubit>(context).startGame();
                  },
                  child: const Text('Start Game')),
              ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<GameCubit>(context).rollDice();
                  },
                  child: const Text('Roll')),
              ElevatedButton(
                  onPressed: () {
                    // BlocProvider.of<GameCubit>(context).updateGameData();
                    PlayerId activePlayerId =
                        BlocProvider.of<GameCubit>(context)
                            .game
                            .activePlayerId!;
                    BlocProvider.of<GameCubit>(context).endTurn();
                  },
                  child: const Text('End Turn')),
              ElevatedButton(
                  onPressed: () async {
                    PlayerId clientPlayerId =
                        BlocProvider.of<GameCubit>(context).clientPlayerId;
                    BlocProvider.of<GameCubit>(context).updateGameData();
                  },
                  child: const Text('Update State')),
              ElevatedButton(
                  onPressed: () async {
                    BlocProvider.of<GameCubit>(context).switchActivePlayerId();
                  },
                  child: const Text('Change to Active Player')),
              // Hardcoded as 0 for now. Will need to adjust this to use
              // a tile and its selected ID.
              ElevatedButton(
                  onPressed: () {
                    PlayerId clientPlayerId =
                        BlocProvider.of<GameCubit>(context).clientPlayerId;
                    final playerLocation = BlocProvider.of<GameCubit>(context)
                        .game
                        .players[clientPlayerId]
                        ?.location;
                    BlocProvider.of<GameCubit>(context)
                        .buyProperty(playerLocation!);
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

class ShowDice extends StatelessWidget {
  const ShowDice({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        return Container(
          child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 400,
                height: 200,
                child: Row(
                  children: [
                    Dice(
                        value1: BlocProvider.of<GameCubit>(context)
                                .game
                                .lastRoll
                                .first ??
                            1,
                        value2: BlocProvider.of<GameCubit>(context)
                                .game
                                .lastRoll
                                .second ??
                            1)
                  ],
                ),
              )),
        );
      },
    );
  }
}
