import 'dart:io';
import 'package:client/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_size/window_size.dart';

import 'package:client/cubit/endpoint_service.dart';
import 'package:client/cubit/event_cubit.dart';
import 'package:client/cubit/file_service.dart';
import 'package:client/cubit/game_cubit.dart';
import 'package:client/model/game.dart';
import 'package:client/view/game_screen/game_screen.dart';
import 'package:client/view/start_screen/start_screen.dart';
import 'package:client/view/start_screen/wait_screen.dart';

void main() {
  // Limit the window resizing (from stackoverflow.com/questions/69755091)
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Monopoly');
    setWindowMinSize(DESKTOP_MAX_SIZE);
  }

  runApp(MonopolyApp());
}

class MonopolyApp extends StatelessWidget {
  MonopolyApp({super.key});

  final backgroundColor = Color(int.parse('FF11202D', radix: 16));

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GameCubit>(
          create: (context) => GameCubit(
              game: Game(),
              fileService: FileService(),
              endpointService: EndpointService()),
        ),
        BlocProvider<EventCubit>(
          create: (context) => EventCubit(
            gameCubit: BlocProvider.of<GameCubit>(context),
          ),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: backgroundColor,
        ),
        initialRoute: '/', // Set the initial route
        routes: {
          '/': (context) => StartScreen(), // Define the StartScreen route
          '/wait': (context) => WaitScreen(), // Define the WaitScreen route
          '/game': (context) => GameScreen(), // Define the GameScreen route
        },
      ),
    );
  }
}
