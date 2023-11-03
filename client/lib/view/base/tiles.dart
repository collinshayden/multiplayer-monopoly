import 'package:client/model/tile_data.dart';
import 'package:flutter/material.dart';
import 'dart:math';

abstract class Tile extends StatelessWidget {
  int id;
  Tile({required this.id, super.key});
}

abstract class SideTile extends Tile {
  String title;
  int quarterTurns;

  SideTile(
      {required super.id,
      required this.quarterTurns,
      required this.title,
      super.key});
}

class ImprovableTile extends SideTile {
  late int color;
  late int price;

  ImprovableTile({
    required super.id,
    required super.quarterTurns,
    required super.title,
    required this.color,
    required this.price,
    super.key,
  });

  ImprovableTile.fromData(ImprovableTileData data) {
    super.id = data.id;
    super.quarterTurns = data.quarterTurns;
    super.title = data.title;
    color = data.color;
    price = data.price;
    super.key;
  }
  

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        child: Column(children: [
          Flexible(
            flex: 1,
            child: Container(color: Color(color)),
          ),
          Flexible(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                      child: Text(
                    title,
                    textAlign: TextAlign.center,
                  )),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text('Price: $price', textAlign: TextAlign.center),
                  )
                ],
              ))
        ]));
  }
}

// class CornerTile extends Tile {
//   final String title;

//   const CornerTile({
//     required super.id,
//     required super.quarterTurns,
//     required this.title,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: Colors.grey,
//         child: Column(
//           children: [
//             Transform.rotate(
//               angle: pi / 4,
//               child: Text(
//                 title,
//               ),
//             )
//           ],
//         ));
//   }
// }

// class ChanceTile extends Tile {
//   final Size size;

//   const ChanceTile({
//     required super.id,
//     required super.quarterTurns,
//     required this.size,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         width: size.width,
//         height: size.height,
//         child: Container(
//             color: Colors.grey,
//             child: Column(
//               children: [
//                 Text(
//                   "Chance",
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             )));
//   }
// }

// class CommunityTile extends SideTile {
//   final Size size;

//   const CommunityTile({
//     required super.id,
//     required super.quarterTurns,
//     required super.title,
//     required this.size,
//     super.key,
//   });

// // TODO fix text wrapping (issue with widget size?)
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         width: size.width,
//         height: size.height,
//         child: Container(
//             color: Colors.grey,
//             child: Column(
//               children: [
//                 Text(
//                   "Community Chest",
//                   textAlign: TextAlign.center,
//                 ),
//                 Spacer(),
//                 Text(
//                   "Follow\n Instructions on Top Card",
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             )));
//   }
// }

// class TaxTile extends SideTile {
//   final Size size;
//   final int payment;

//   const TaxTile({
//     required super.id,
//     required super.title,
//     required super.quarterTurns,
//     required this.size,
//     required this.payment,
//     super.key,
//   });

// // TODO fix text wrapping (issue with widget size?)
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         width: size.width,
//         height: size.height,
//         child: Container(
//             color: Colors.grey,
//             child: Column(
//               children: [
//                 Text(
//                   title,
//                   textAlign: TextAlign.center,
//                 ),
//                 Spacer(),
//                 Padding(
//                     padding: EdgeInsets.only(bottom: size.height / 10),
//                     child: Text('Pay: $payment'))
//               ],
//             )));
//   }
// }

// class UtilityTile extends SideTile {
//   final Size size;
//   final int price;

//   const UtilityTile({
//     required super.id,
//     required super.title,
//     required super.quarterTurns,
//     required this.size,
//     required this.price,
//     super.key,
//   });

// // TODO fix text wrapping (issue with widget size?)
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         width: size.width,
//         height: size.height,
//         child: Container(
//             color: Colors.grey,
//             child: Column(
//               children: [
//                 Text(
//                   title,
//                   textAlign: TextAlign.center,
//                 ),
//                 Spacer(),
//                 Padding(
//                     padding: EdgeInsets.only(bottom: size.height / 10),
//                     child: Text('Price: $price'))
//               ],
//             )));
//   }
// }
