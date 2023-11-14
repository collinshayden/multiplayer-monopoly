import 'package:client/cubit/game_cubit.dart';
import 'package:client/model/player.dart';
import 'package:client/model/roll.dart';
import 'package:client/model/tiles.dart';
import 'package:client/view/base/board.dart';
import 'package:client/view/dice.dart';
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
              CubitTest(),
              Board(),
              Center(
                child: SizedBox.fromSize(
                  size: const Size(100.0, 150.0),
                  child: Column(
                    children: [
                      Align(),
                      // Roll(first: 1, second: 4).createWidget(),
                    ],
                  ),
                ),
              ),
              // TODO admin buttons will go here
              Spacer(),
              Center(child: AdminButtons()),
              ShowDice(),
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
            child: Text('Load local config'),
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
        return Container(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                TextButton(
                    onPressed: () {
                      BlocProvider.of<GameCubit>(context)
                          .endpointService
                          .reset("admin");
                    },
                    child: Text('Reset')),
                TextButton(
                    onPressed: () {
                      BlocProvider.of<GameCubit>(context)
                          .joinGame(displayName: "testUser");
                    },
                    child: Text('Join')),
                TextButton(
                    onPressed: () {
                      BlocProvider.of<GameCubit>(context).updateGameData();
                      BlocProvider.of<GameCubit>(context)
                          .endpointService
                          .startGame(playerId: PlayerId("admin"));
                    },
                    child: Text('Start Game')),
                TextButton(
                    onPressed: () {
                      BlocProvider.of<GameCubit>(context).updateGameData();
                      PlayerId activePlayerId =
                          BlocProvider.of<GameCubit>(context)
                              .game
                              .activePlayerId!;
                      BlocProvider.of<GameCubit>(context)
                          .rollDice(playerId: activePlayerId);
                    },
                    child: Text('Roll')),
                TextButton(
                    onPressed: () {
                      BlocProvider.of<GameCubit>(context).updateGameData();
                    },
                    child: Text('Update')),
              ],
            ),
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
                  children: [Dice(value1: BlocProvider.of<GameCubit>(context).game.lastRoll.first ?? 1, value2: BlocProvider.of<GameCubit>(context).game.lastRoll.second ?? 1)],
                ),
              )),
        );
      },
    );
  }
}
