/// Socket.IO test program
/// Author: Alex Hall
/// Date: 10/12/2023

import 'package:client/view/base/board.dart';
import 'package:flutter/material.dart';
import 'cubit/game_manager_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

/// This application demonstrates Socket.IO functionality, including connection,
/// connection error, disconnection, and a custom event handler. The user is
/// able to enter text into a text field and hit the send button. The console
/// will then print the entered text only if the server has received it and sent
/// it back to the client.

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
          create: (context) => GameManagerCubit(),
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
