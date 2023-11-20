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
          appBar: AppBar(
            title: const Text('Admin Buttons'),
          ),
          body: Column(
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
                    BlocProvider.of<GameCubit>(context).switchActivePlayerId();
                  },
                  child: const Text('Change to Active Player')),
              // Hardcoded as the client player's active tile.
              ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<GameCubit>(context).buyProperty();
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
        ));
  }
}

/// Signature for callbacks used to create [AdminButtons]s. Callbacks which are
/// assigned through this callback will be called with a [BuildContext] object
/// and can thus access any inherited Bloc/Cubit objects, as well as anything
/// else normally accessed through a `.of(context)` call.
typedef ContextualCallback = void Function(BuildContext context);

/// A button used in the [AdminPanel] widget.
///
/// This is one of a number of possible tools which can be included in the list
/// of tools provided by the [AdminPanel]. This button takes a
/// [ContextualCallback] and constructs a button wired to it.
class AdminButton extends StatelessWidget {
  const AdminButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final ContextualCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      // Passes `context` into given callback, allowing it to find the GameCubit.
      onTap: () => onPressed(context),
    );
  }
}
