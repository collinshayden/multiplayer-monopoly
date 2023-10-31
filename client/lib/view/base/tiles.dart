import 'package:flutter/material.dart';

abstract class Tile extends StatelessWidget {
  const Tile({super.key});
}

class AssetTile extends Tile {
  final int id;
  final Size size;
  final Color color;
  final String name;
  final int price;

  const AssetTile({
    required this.id,
    required this.size,
    required this.color,
    required this.name,
    required this.price,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
            color: Colors.grey,
            child: Column(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height / 4,
                  child: Container(color: color),
                ),
                Center(
                    child: Text(
                  '$name',
                  textAlign: TextAlign.center,
                )),
                Spacer(),
                Padding(
                    padding: EdgeInsets.only(bottom: size.height / 10),
                    child: Text('Price: $price'))
              ],
            )));
  }
}
