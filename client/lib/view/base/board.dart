import 'package:flutter/material.dart';
import 'package:client/view/base/background.dart';
import 'package:client/view/base/tiles.dart';

class Board extends StatelessWidget {
  const Board({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Stack(
        children: [
          const Background(),
          GridView.count(
            crossAxisCount: 8,
            children: [
              PropertyTile(
                id: 0,
                size: Size(100, 100),
                color: Colors.red,
                name: 'GO',
                price: 0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
