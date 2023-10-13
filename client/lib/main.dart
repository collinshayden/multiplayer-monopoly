/// Socket.IO test program
/// Author: Alex Hall
/// Date: 10/12/2023

import 'package:flutter/material.dart';
import 'package:client/view/base/board.dart';
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Board()),
    );
  }
}
