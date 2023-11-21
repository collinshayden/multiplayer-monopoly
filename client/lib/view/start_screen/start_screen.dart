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
      body: Center(
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

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WaitScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
