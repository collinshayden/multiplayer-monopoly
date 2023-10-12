/// Socket.IO test program
/// Author: Alex Hall
/// Date: 10/12/2023

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

/// This application demonstrates Socket.IO functionality, including connection,
/// connection error, disconnection, and a custom event handler. The user is
/// able to enter text into a text field and hit the send button. The console
/// will then print the entered text only if the server has received it and sent
/// it back to the client.

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  _AppState();

  final TextEditingController _controller = TextEditingController();
  late socket_io.Socket _socket;

  @override
  void initState() {
    super.initState();

    // Socket setup
    print(socket_io.protocol);

    _socket = socket_io.io(
      'http://localhost:5000',
      socket_io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket.onConnect(
        (data) => print('(Socket.IO) connect: Connected to server.'));
    _socket.onConnectError((data) => print('(Socket.IO) connect_error: $data'));
    _socket.onDisconnect(
        (data) => print('(Socket.IO) disconnect: Disconnected from server.'));
    _socket.on(
      'custom_event',
      (data) {
        print('(Socket.IO) custom_event: $data');
      },
    );

    _socket.connect();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendCustomEvent() {
    if (_controller.text.isNotEmpty) {
      _socket.emit('custom_event', _controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Socket.IO Demo';

    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 200,
              maxWidth: 300,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: TextFormField(
                          controller: _controller,
                          decoration: const InputDecoration(
                              labelText: 'Type some text')),
                    ),
                  ),
                ),
                FloatingActionButton.small(
                  onPressed: _sendCustomEvent,
                  tooltip: 'Send text',
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
