import 'package:client/constants.dart';
import 'package:client/cubit/game_cubit.dart';
import 'package:client/view/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerControls extends StatefulWidget {
  const PlayerControls({super.key});

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

// Commented out admin buttons
class _PlayerControlsState extends State<PlayerControls> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Controls'),
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MultiOptionWidget(
                      defaultText: "Select Jail method",
                      options: const [
                        {'text': 'Card', 'value': JailMethod.card},
                        // {'text': 'Doubles', 'value': JailMethod.doubles},
                        {'text': 'Money', 'value': JailMethod.money},
                      ],
                      onPressed: (value) {
                        BlocProvider.of<GameCubit>(context).getOutOfJail(value) ?? "Money";
                      }),
                  ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<GameCubit>(context).rollDice();
                      },
                      child: const Text('Roll')),
                  ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<GameCubit>(context).buyProperty();
                      },
                      child: const Text('Buy Property')),
                  ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<GameCubit>(context).endTurn();
                      },
                      child: const Text('End Turn')),
                ],
              ),
            ),
          ),
        ));
  }
}
