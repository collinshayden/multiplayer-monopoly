import 'package:flutter/material.dart';
import 'package:client/view/base/tiles.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  late List<Widget> tiles = List.generate(
    40,
    (index) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Tile(index: index),
      );
    },
    growable: false,
  );

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: GridView.count(
        crossAxisCount: 8,
        children: tiles,
      ),
    );
  }
}
