import 'package:flutter/material.dart';
import 'package:client/view/base/board.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Board(),
        ),
      ),
    );
  }
}
