import 'package:client/constants.dart';
import 'package:client/cubit/game_cubit.dart';
import 'package:client/view/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Admin Buttons'),
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<GameCubit>(context)
                            .resetGame(useAdmin: true);
                      },
                      child: const Text('Reset')),
                  TextInputWidget(
                      width: 200,
                      labelText: "Enter Name",
                      buttonText: "Join Game",
                      labelTextColor: Colors.black,
                      center: false,
                      onPressed: (value) {
                        BlocProvider.of<GameCubit>(context)
                            .registerPlayer(displayName: value);
                      }),
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
                        BlocProvider.of<GameCubit>(context).endTurn();
                      },
                      child: const Text('End Turn')),
                  ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<GameCubit>(context)
                            .updateGameData(useAdmin: true);
                      },
                      child: const Text('Update State')),
                  ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<GameCubit>(context)
                            .switchToActivePlayerId();
                        BlocProvider.of<GameCubit>(context).updateGameData();
                      },
                      child: const Text('Change to Active Player')),
                  // Hardcoded as the client player's active tile.
                  ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<GameCubit>(context).buyProperty();
                      },
                      child: const Text('Buy Property')),
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
                ],
              ),
            ),
          ),
        ));
  }
}
