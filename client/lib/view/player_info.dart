import 'package:flutter/material.dart';
import 'package:client/model/player.dart'; // Make sure to import your Player class

class PlayerInfoScreen extends StatelessWidget {
  final Player player;

  PlayerInfoScreen({required this.player});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.black.withOpacity(0.8), // Adjust the opacity as needed
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Player Information',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              // TODO: Remove ID once we no longer want it
              Text('ID: ${player.id.value}'),
              Text('Display Name: ${player.displayName ?? 'N/A'}'),
              Text('Money: ${player.money ?? 0}'),
              Text('Location: ${player.location ?? 0}'),
              Text(
                  'Get Out of Jail Free Cards: ${player.getOutOfJailFreeCards ?? 0}'),
              // Add more information as needed
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the player info screen
                },
                child: Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
