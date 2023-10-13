/// Socket.IO test program
/// Author: Alex Hall
/// Date: 10/12/2023

import 'package:client/view/base/background.dart';
import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as socket_io;

/// This application demonstrates Socket.IO functionality, including connection,
/// connection error, disconnection, and a custom event handler. The user is
/// able to enter text into a text field and hit the send button. The console
/// will then print the entered text only if the server has received it and sent
/// it back to the client.

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Monopoly(),
    ),
  );
}

class Monopoly extends StatefulWidget {
  const Monopoly({super.key});

  @override
  State<Monopoly> createState() => _MonopolyState();
}

class _MonopolyState extends State<Monopoly> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Background());
  }
}
