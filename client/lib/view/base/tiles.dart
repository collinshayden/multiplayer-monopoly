import 'package:client/model/player_data.dart';
import 'package:client/model/tile_data.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ImprovableTile extends StatefulWidget {
  final ImprovableTileData data;
  const ImprovableTile({
    required this.data,
    super.key,
  });

  @override
  State<ImprovableTile> createState() => _ImprovableTileState();
}

class _ImprovableTileState extends State<ImprovableTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        child: Column(children: [
          Flexible(
            flex: 1,
            child: Container(color: Colors.red),
          ),
          Flexible(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                      child: Text(
                    widget.data.title!,
                    textAlign: TextAlign.center,
                  )),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text('Price: ${widget.data.price}',
                        textAlign: TextAlign.center),
                  )
                ],
              ))
        ]));
  }
}

class CornerTile extends StatefulWidget {
  final CornerTileData data;
  const CornerTile({
    required this.data,
    super.key,
  });

  @override
  State<CornerTile> createState() => _CornerTileState();
}

class _CornerTileState extends State<CornerTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        child: Column(
          children: [
            Transform.rotate(
              angle: pi / 4,
              child: Text(
                widget.data.title!,
              ),
            )
          ],
        ));
  }
}

class ChanceTile extends StatefulWidget {
  final ChanceTileData data;
  const ChanceTile({
    required this.data,
    super.key,
  });

  @override
  State<ChanceTile> createState() => _ChanceTileState();
}

class _ChanceTileState extends State<ChanceTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        child: Column(
          children: [
            Transform.rotate(
              angle: pi / 4,
              child: Text(
                widget.data.title!,
              ),
            )
          ],
        ));
  }
}

class CommunityTile extends StatefulWidget {
  final CommunityTileData data;
  const CommunityTile({
    required this.data,
    super.key,
  });

  @override
  State<CommunityTile> createState() => _CommunityTileState();
}

class _CommunityTileState extends State<CommunityTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        child: Column(
          children: [
            Transform.rotate(
              angle: pi / 4,
              child: Text(
                widget.data.title!,
              ),
            )
          ],
        ));
  }
}

class TaxTile extends StatefulWidget {
  final TaxTileData data;
  const TaxTile({required this.data, super.key});

  @override
  State<TaxTile> createState() => _TaxTileState();
}

class _TaxTileState extends State<TaxTile> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class UtilityTile extends StatefulWidget {
  final UtilityTileData data;
  const UtilityTile({required this.data, super.key});

  @override
  State<UtilityTile> createState() => _UtilityTileState();
}

class _UtilityTileState extends State<UtilityTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        child: Column(
          children: [
            Transform.rotate(
              angle: pi / 4,
              child: Text(
                widget.data.title!,
              ),
            )
          ],
        ));
  }
}

class RailroadTile extends StatefulWidget {
  final RailroadTileData data;
  const RailroadTile({required this.data, super.key});

  @override
  State<RailroadTile> createState() => _RailroadTileState();
}

class _RailroadTileState extends State<RailroadTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        child: Column(
          children: [
            Transform.rotate(
              angle: pi / 4,
              child: Text(
                widget.data.title!,
              ),
            )
          ],
        ));
  }
}