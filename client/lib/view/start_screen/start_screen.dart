import 'package:client/view/start_screen/wait_screen.dart';
import 'package:flutter/material.dart';
import 'package:client/view/widgets.dart';
import 'package:client/view/game_screen/game_screen.dart';
import 'package:client/cubit/game_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key});

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
                  TextInputWidget(
                    width: 200,
                    labelText: "Enter Name",
                    buttonText: "Join Game",
                    onPressed: (value) {
                      BlocProvider.of<GameCubit>(context)
                          .registerPlayer(displayName: value);
                      BlocProvider.of<GameCubit>(context)
                          .updateGameData(useAdmin: true);

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
                          horizontal: 30, vertical: 15), // Adjust padding as needed
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