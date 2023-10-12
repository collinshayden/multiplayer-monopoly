import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  const Tile({super.key});

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  late String name;
  late num price;
  Set<Widget> tokens = {};

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
