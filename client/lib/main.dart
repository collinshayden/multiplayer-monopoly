import 'package:client/cubit/game_cubit.dart';
import 'package:client/model/player.dart';
import 'package:client/model/roll.dart';
import 'package:client/model/tiles.dart';
import 'package:client/view/base/board.dart';
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
                      DiceRollButton(),
                      // Roll(first: 1, second: 4).createWidget(),
                    ],
                  ),
                ),
              ),
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

class DiceRollButton extends StatelessWidget {
  const DiceRollButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        BlocProvider.of<GameCubit>(context).endpointService.startGame();
        BlocProvider.of<GameCubit>(context).joinGame(displayName: "player1");
        BlocProvider.of<GameCubit>(context).joinGame(displayName: "player2");
        BlocProvider.of<GameCubit>(context).endpointService.getGameData();
        PlayerId activePlayerId = BlocProvider.of<GameCubit>(context).game.activePlayerId!;
        BlocProvider.of<GameCubit>(context).rollDice(playerId: activePlayerId.value);
        Roll lastRoll = BlocProvider.of<GameCubit>(context).game.lastRoll!;
        print(lastRoll.first);
        BlocProvider.of<GameCubit>(context).endpointService.reset(activePlayerId.value);

        // String active_player_id = 
        
        print('Rolling dice!');
      },
      child: const Text('Roll Dice!'),
    );
  }
}
