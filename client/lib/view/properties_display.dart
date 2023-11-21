/// File containing the classes for viewing/editing properties.
/// Author: Jordan Bourdeau
/// Date: 11/20/2023

import 'package:client/cubit/game_cubit.dart';
import 'package:client/model/asset_enums.dart';
import 'package:flutter/material.dart';
import 'package:client/model/player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaddedText extends StatelessWidget {
  final String text;
  final bool bold;

  PaddedText({required this.text, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Text(
        text,
        style:
            TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}

/// Widget for common pattern of <Text> <Dollar amount>
class TextAmountWidget extends StatelessWidget {
  final String text;
  final int amount;

  TextAmountWidget({required this.text, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, textAlign: TextAlign.left),
          Text('\$$amount', textAlign: TextAlign.right),
        ],
      ),
    );
  }
}

class SpacerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Colors.black, // You can customize the color as needed
      margin:
          EdgeInsets.symmetric(vertical: 8), // Adjust vertical margin as needed
    );
  }
}

class PropertyInfo extends StatelessWidget {
  final Map<String, dynamic> property;
  var titleDeed;

  PropertyInfo({
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = getPropertyGroupColor(property);
    List<Widget> children = [];

    switch (property['type']) {
      case ('improvable'):
        children.addAll([
          Container(
            alignment: Alignment.center,
            color: backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  PaddedText(text: 'Title Deed'),
                  PaddedText(
                      text: property['name'] ?? 'Unknown Property', bold: true)
                ],
              ),
            ),
          ),
          TextAmountWidget(text: 'Rent', amount: property['baseRent']),
          TextAmountWidget(
              text: 'With 1 House', amount: property['oneImprovement']),
          TextAmountWidget(
              text: 'With 2 House', amount: property['twoImprovements']),
          TextAmountWidget(
              text: 'With 3 House', amount: property['threeImprovements']),
          TextAmountWidget(
              text: 'With 4 House', amount: property['fourImprovements']),
          TextAmountWidget(
              text: 'With Hotel', amount: property['fiveImprovements']),
          SpacerLine(),
          TextAmountWidget(
              text: 'Mortgage Value', amount: property['mortgagePrice']),
          TextAmountWidget(
              text: 'Houses Cost', amount: property['improvementCost']),
          TextAmountWidget(
              text: 'Hotels Cost', amount: property['improvementCost']),
          Padding(
              padding: EdgeInsets.fromLTRB(4.0, 12.0, 4.0, 0.0),
              child: Text(
                'If a player owns ALL the Lots of any Color-Group, the rent is Doubled on Unimproved Lots in that group.',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12.0),
              )),
        ]);
        break;
      case ('utility'):
        final imageLocation = property['name'] == 'Electric Company'
            ? 'assets/images/electric_company.png'
            : 'assets/images/water_works.png';
        children.addAll(
          [
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.asset(imageLocation, height: 80, width: 80),
                    SpacerLine(),
                    PaddedText(
                        text: property['name'] ?? 'Unknown Property',
                        bold: true),
                    SpacerLine(),
                  ],
                ),
              ),
            ),
            PaddedText(
              text:
                  'If one "Utility" is owned rent is 4 times amount shown on dice',
            ),
            PaddedText(
              text:
                  'If both "Utilities" are owned rent is 10 times amount shown on dice',
            ),
            TextAmountWidget(
              text: 'Mortgage Value',
              amount: property['mortgagePrice'],
            ),
          ],
        );
        break;
      case ('railroad'):
        children.addAll(
          [
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.asset('assets/images/railroad.png',
                        height: 80, width: 80),
                    SpacerLine(),
                    PaddedText(
                        text: property['name'] ?? 'Unknown Property',
                        bold: true),
                    SpacerLine(),
                  ],
                ),
              ),
            ),
            TextAmountWidget(text: 'Rent', amount: property['oneOwned']),
            TextAmountWidget(
              text: 'If 2 R.R.\'s are owned',
              amount: property['twoOwned'],
            ),
            TextAmountWidget(
              text: 'If 3       "   "     "',
              amount: property['threeOwned'],
            ),
            TextAmountWidget(
              text: 'If 4       "   "     "',
              amount: property['fourOwned'],
            ),
            TextAmountWidget(
                text: 'Mortgage Value', amount: property['mortgagePrice'])
          ],
        );
        break;
      case _:
    }
    final titalDeed = Container(
      padding: EdgeInsets.all(16),
      width: 275,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 25,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(padding: EdgeInsets.all(16), child: titalDeed),
    );
  }

  Color getPropertyGroupColor(Map<String, dynamic> property) {
    // Define colors for different property groups
    Map<String, Color> groupColors = {
      'BROWN': Colors.brown,
      'LIGHT_BLUE': Colors.lightBlue,
      'PINK': Colors.pink,
      'ORANGE': Colors.orange,
      'RED': Colors.red,
      'YELLOW': Colors.yellow,
      'GREEN': Colors.green,
      'DARK_BLUE': Colors.blue,
      // Add more colors as needed
    };

    // Get property group from the property map
    String? propertyGroup = property['group'];

    // Return the corresponding color or a default color
    return groupColors[propertyGroup] ?? Colors.grey;
  }

  String getStatusText(Map<String, dynamic> property) {
    String statusText = 'Unknown';
    if (property.containsKey('status')) {
      switch (property['status']) {
        case 'NO_MONOPOLY':
          statusText = 'No Monopoly';
          break;
        case 'MONOPOLY':
          statusText = 'Monopoly';
          break;
        case 'ONE_IMPROVEMENT':
          statusText = 'One Improvement';
          break;
        case 'TWO_IMPROVEMENTS':
          statusText = 'Two Improvements';
          break;
        case 'THREE_IMPROVEMENTS':
          statusText = 'Three Improvements';
          break;
        case 'FOUR_IMPROVEMENTS':
          statusText = 'Four Improvements';
          break;
        case 'FIVE_IMPROVEMENTS':
          statusText = 'Five Improvements';
          break;
        case 'UNOWNED':
          statusText = 'Unowned';
          break;
        case 'ONE_OWNED':
          statusText = 'One Owned';
          break;
        case 'TWO_OWNED':
          statusText = 'Two Owned';
          break;
        case 'THREE_OWNED':
          statusText = 'Three Owned';
          break;
        case 'FOUR_OWNED':
          statusText = 'Four Owned';
          break;
      }
    }
    return statusText;
  }
}

class PropertyList extends StatelessWidget {
  final List<Map<String, dynamic>> assets;
  bool isExpanded = false;

  PropertyList({
    required this.assets,
  });

  @override
  Widget build(BuildContext context) {
    // Group properties by their 'group' property
    Map<String, List<Map<String, dynamic>>> groupedProperties = {};

    for (var property in assets) {
      String group = property['group'] ?? 'Other';
      groupedProperties.putIfAbsent(group, () => []);
      groupedProperties[group]!.add(property);
    }

    // Need a Container to limit height
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: groupedProperties.length,
        itemBuilder: (context, index) {
          String group = groupedProperties.keys.elementAt(index);
          List<Map<String, dynamic>> properties = groupedProperties[group]!;

          // Create a unique ScrollController for each row
          ScrollController scrollController = ScrollController();

          return Scrollbar(
            controller: scrollController,
            trackVisibility: true,
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: properties
                    .map((property) => PropertyInfo(property: property))
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
