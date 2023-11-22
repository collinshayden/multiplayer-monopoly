import 'package:client/cubit/game_cubit.dart';
import 'package:client/view/admin_panel.dart';
import 'package:client/view/game_screen/board.dart';
import 'package:client/view/player_controls.dart';
import 'package:client/view/player_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget contains the screen on which the game is played.
class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool isPlayerDisplayExpanded = true;
  bool arePlayerControlsExpanded = true;
  bool areAdminButtonsExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Load or reload local configuration whenever the game screen is rebuilt.
    BlocProvider.of<GameCubit>(context).loadLocalConfig();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monopoly'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Text(
                    'Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(width: 48.0), // Adjust the width as needed
                ],
              ),
            ),
            SizedBox(height: 16.0), // Add spacing between header and switches
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Player Display',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      Switch(
                        value: isPlayerDisplayExpanded,
                        onChanged: (value) {
                          setState(() {
                            isPlayerDisplayExpanded = value;
                          });
                        },
                        activeColor: Colors.black,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0), // Add spacing between switches
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Player Controls',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      Switch(
                        value: arePlayerControlsExpanded,
                        onChanged: (value) {
                          setState(() {
                            arePlayerControlsExpanded = value;
                          });
                        },
                        activeColor: Colors.black,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Admin Controls',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      Switch(
                        value: areAdminButtonsExpanded,
                        onChanged: (value) {
                          setState(() {
                            areAdminButtonsExpanded = value;
                          });
                        },
                        activeColor: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Add more items as needed
          ],
        ),
      ),
      body: Row(
        children: [
          Visibility(
            visible: isPlayerDisplayExpanded,
            child: Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: PlayerDisplay(),
              ),
            ),
          ),
          Expanded(
            flex: isPlayerDisplayExpanded ? 2 : 3,
            child: const Board(),
          ),
          Visibility(
            visible: areAdminButtonsExpanded,
            child: Expanded(
              flex: 1,
              child: AdminPanel(),
            ),
          ),
          Visibility(
            visible: arePlayerControlsExpanded,
            child: Expanded(
              flex: 1,
              child: PlayerControls(),
            ),
          ),
        ],
      ),
    );
  }
}
