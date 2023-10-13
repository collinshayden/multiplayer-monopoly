import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  final int index;

  const Tile({required this.index, super.key});

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  late String name;
  late num price;
  Set<Widget> tokens = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(3.0)),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: FittedBox(
          child: Text(
            'Tile ${widget.index + 1}',
            style:
                const TextStyle(fontFamily: 'Helvetica', color: Colors.black),
          ),
        ),
      ),
    );
  }
}
