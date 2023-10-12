import 'package:flutter/material.dart';
import 'package:client/view/base/tiles.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  late List<Tile> tiles;

  @override
  initState() {
    super.initState();

    tiles = List.generate(
      40,
      (index) {
        return Tile();
      },
      growable: false,
    );
  }

  @override
  dispose() {
    // ...
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: GridView.count(crossAxisCount: 10, children: [Placeholder()]),
    );
  }
}
