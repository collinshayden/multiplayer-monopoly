import 'package:client/view/start_screen/wait_screen.dart';
import 'package:flutter/material.dart';
import 'package:client/view/widgets.dart';
import 'package:client/view/game_screen/game_screen.dart';
import 'package:client/cubit/game_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key});
  static const textColor = Color(0xFFFFF0E6);

  @override
  Widget build(BuildContext context) {
    // Load this here so it is already loaded when a player registers.
    BlocProvider.of<GameCubit>(context).loadLocalConfig();
    return Scaffold(
      backgroundColor: Color(int.parse('FF11202D', radix: 16)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 100, bottom: 20),
            child: Text(
              'Welcome to Monopoly',
              style: TextStyle(
                color: textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            'Created by Aidan Bonner, Jordan Bourdeau, Hayden Collins, and Alex Hall',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontStyle: FontStyle.normal,
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextInputWidget(
                    width: 200,
                    labelText: "Enter Name",
                    buttonText: "Join Game",
                    labelTextColor: textColor,
                    onPressed: (value) {
                      BlocProvider.of<GameCubit>(context)
                          .registerPlayer(displayName: value);
                      Navigator.pushNamed(context, '/wait');
                    },
                  ),
                  const SizedBox(height: 20), // Adding space between widgets
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<GameCubit>(context)
                          .resetGame(useAdmin: true);
                    },
                    child: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15), // Adjust padding as needed
                    ),
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
