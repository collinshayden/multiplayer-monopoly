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

class CornerTile extends Tile {
  final int id;
  final Size size;
  final String name;

  const CornerTile({
    required this.id,
    required this.size,
    required this.name,
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
                Text(
                  name,
                  textAlign: TextAlign.center,
                ),
              ],
            )));
  }
}

class ChanceTile extends Tile {
  final int id;
  final Size size;

  const ChanceTile({
    required this.id,
    required this.size,
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
                Text(
                  "Chance",
                  textAlign: TextAlign.center,
                ),
              ],
            )));
  }
}

class CommunityTile extends Tile {
  final int id;
  final Size size;

  const CommunityTile({
    required this.id,
    required this.size,
    super.key,
  });

// TODO fix text wrapping (issue with widget size?)
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
            color: Colors.grey,
            child: Column(
              children: [
                Text(
                  "Community Chest",
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Text(
                  "Follow\n Instructions on Top Card",
                  textAlign: TextAlign.center,
                ),
              ],
            )));
  }
}

class TaxTile extends Tile {
  final int id;
  final String name;
  final Size size;
  final int payment;

  const TaxTile({
    required this.id,
    required this.size,
    required this.name,
    required this.payment,
    super.key,
  });

// TODO fix text wrapping (issue with widget size?)
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
            color: Colors.grey,
            child: Column(
              children: [
                Text(
                  name,
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Padding(
                    padding: EdgeInsets.only(bottom: size.height / 10),
                    child: Text('Pay: $payment'))
              ],
            )));
  }
}

class UtilityTile extends Tile {
  final int id;
  final String name;
  final Size size;
  final int price;

  const UtilityTile({
    required this.id,
    required this.size,
    required this.name,
    required this.price,
    super.key,
  });

// TODO fix text wrapping (issue with widget size?)
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
            color: Colors.grey,
            child: Column(
              children: [
                Text(
                  name,
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Padding(
                    padding: EdgeInsets.only(bottom: size.height / 10),
                    child: Text('Price: $price'))
              ],
            )));
  }
}
