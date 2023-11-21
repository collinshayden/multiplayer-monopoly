/// File containing the classes for viewing/editing properties.
/// Author: Jordan Bourdeau
/// Date: 11/20/2023

import 'package:client/cubit/game_cubit.dart';
import 'package:client/model/asset_enums.dart';
import 'package:client/view/widgets.dart';
import 'package:flutter/material.dart';
import 'package:client/model/player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PropertyInfo extends StatelessWidget {
  final Map<String, dynamic> property;
  bool showButtons;
  var titleDeed;

  PropertyInfo({
    required this.property,
    required this.showButtons,
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
    // Only show the buttons to edit a property (mortgage/improve/degrade)
    // if showButtons flag is set to true
    // Inside the showButtons block
    List<Widget> propertyButtons = [];
    if (showButtons) {
      if (property['isMortgaged']) {
        // Mortgage Button
        propertyButtons.add(
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<GameCubit>(context)
                  .setMortgage(property['id'], false);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red, // Adjust color accordingly
              textStyle: TextStyle(color: Colors.white),
            ),
            child: Text('Unmortgage'),
          ),
        );
      } else {
        // Unmortgage Button
        propertyButtons.add(
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<GameCubit>(context)
                  .setMortgage(property['id'], true);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green, // Adjust color accordingly
              textStyle: TextStyle(color: Colors.white),
            ),
            child: Text('Mortgage'),
          ),
        );
      }

      // Improve Button (Placeholder)
      propertyButtons.add(
        ElevatedButton(
          onPressed: () {
            // Call BlocProvider.of<GameCubit>(context).improveProperty(property['id']);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, // Adjust color accordingly
            textStyle: TextStyle(color: Colors.white),
          ),
          child: Text('Improve'),
        ),
      );

      // Degrade Button (Placeholder)
      propertyButtons.add(
        ElevatedButton(
          onPressed: () {
            // Call BlocProvider.of<GameCubit>(context).degradeProperty(property['id']);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.orange, // Adjust color accordingly
            textStyle: TextStyle(color: Colors.white),
          ),
          child: Text('Degrade'),
        ),
      );
    }

    final titalDeed = Container(
      padding: EdgeInsets.all(16),
      width: 275,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
          if (property['isMortgaged'])
            Positioned.fill(
              child: Transform.rotate(
                angle: -45 * 3.1415927 / 180,
                child: Container(
                  child: Center(
                    child: Text(
                      'Mortgaged',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(children: [titalDeed, ...propertyButtons])),
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
  final Player player;
  bool isExpanded = false;

  PropertyList({
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> assets = player.assets;
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
          print(player.id);
          print(BlocProvider.of<GameCubit>(context).clientPlayerId);
          print(BlocProvider.of<GameCubit>(context).game.activePlayerId);

          // Create a unique ScrollController for each row
          var showPropertyButtons =
              player.id == BlocProvider.of<GameCubit>(context).clientPlayerId &&
                  player.id ==
                      BlocProvider.of<GameCubit>(context).game.activePlayerId;
          ScrollController scrollController = ScrollController();
          var groupProperties = properties
              .map((property) => PropertyInfo(
                  property: property, showButtons: showPropertyButtons))
              .toList();
          // If the active player is also the client, add the
          return Scrollbar(
            controller: scrollController,
            trackVisibility: true,
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: groupProperties,
              ),
            ),
          );
        },
      ),
    );
  }
}
