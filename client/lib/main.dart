import 'package:client/cubit/game_cubit.dart';
import 'package:client/view/base/board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This application demonstrates Socket.IO functionality, including connection,
/// connection error, disconnection, and a custom event handler. The user is
/// able to enter text into a text field and hit the send button. The console
/// will then print the entered text only if the server has received it and sent
/// it back to the client.

void main() {
  // Dependency injection here
  // Initialise get_it singleton
  // register lazy singletons

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
              const Board(),
              Center(
                child: SizedBox.fromSize(
                  size: const Size(100.0, 50.0),
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          print('Rolling dice!');
                        },
                        child: const Text('Roll Dice!'),
                      )
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
