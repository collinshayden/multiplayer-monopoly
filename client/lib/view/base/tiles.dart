import 'package:flutter/material.dart';

abstract class Tile extends StatelessWidget {
  const Tile({super.key});
}

class PropertyTile extends Tile {
  final int id;
  final Size size;
  final Color color;
  final String name;
  final int price;

  const PropertyTile({
    required this.id,
    required this.size,
    required this.color,
    required this.name,
    required this.price,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Center(child: Text('$id: $name')),
    );
  }
}
