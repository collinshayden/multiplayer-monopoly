/// File containing the classes for viewing/editing properties.
/// Author: Jordan Bourdeau
/// Date: 11/20/2023

import 'package:client/constants.dart';
import 'package:client/cubit/game_cubit.dart';
import 'package:client/model/asset_enums.dart';
import 'package:client/view/widgets.dart';
import 'package:flutter/material.dart';
import 'package:client/model/player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnmortgageButton extends StatelessWidget {
  final VoidCallback onPressed;

  UnmortgageButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
        textStyle: TextStyle(color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 20),
      ),
      child: Text('Unmortgage'),
    );
  }
}

class MortgageButton extends StatelessWidget {
  final VoidCallback onPressed;

  MortgageButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
        textStyle: TextStyle(color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 20),
      ),
      child: Text('Mortgage'),
    );
  }
}

// Widget used to build/degrade the number of improvements on a property
class ImprovementsButton extends StatefulWidget {
  final int currentImprovements;
  final ValueChanged<int> onChanged;

  ImprovementsButton({
    required this.currentImprovements,
    required this.onChanged,
  });

  @override
  _ImprovementsButtonState createState() => _ImprovementsButtonState();
}

class _ImprovementsButtonState extends State<ImprovementsButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.currentImprovements > 0)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                widget.onChanged(-1);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                textStyle: TextStyle(color: Colors.white),
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text('Degrade'),
            ),
          ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            widget.currentImprovements.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(height: 8),
        if (widget.currentImprovements < MAX_NUM_IMPROVEMENTS)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                widget.onChanged(1);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                textStyle: TextStyle(color: Colors.white),
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text('Improve'),
            ),
          ),
      ],
    );
  }
}

class PropertyInfo extends StatefulWidget {
  final Map<String, dynamic> property;
  bool showButtons;

  PropertyInfo({
    required this.property,
    required this.showButtons,
  });

  @override
  _PropertyInfoState createState() => _PropertyInfoState();
}

class _PropertyInfoState extends State<PropertyInfo> {
  bool isMouseOver = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = getPropertyGroupColor(widget.property);
    List<Widget> children = [];
    Map<String, dynamic> property = widget.property;

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

    List<Widget> propertyButtons = [];
    if (widget.showButtons) {
      if (widget.property['isMortgaged']) {
        propertyButtons.add(UnmortgageButton(onPressed: () {
          BlocProvider.of<GameCubit>(context)
              .setMortgage(property['id'], false);
        }));
      } else {
        propertyButtons.add(MortgageButton(onPressed: () {
          BlocProvider.of<GameCubit>(context).setMortgage(property['id'], true);
        }));
      }
      // Being able to upgrade a property only applies with a property that can
      // be upgraded where all others of a color are owned.
      if (widget.property['type'] == 'improvable' &&
          widget.property['status'] != 'NO_MONOPOLY' &&
          !widget.property['isMortgaged']) {
        propertyButtons.add(ImprovementsButton(
            currentImprovements: getNumImprovements(property['status']),
            onChanged: (quantity) {
              // print("Changing improvements by $quantity improvements.");
              BlocProvider.of<GameCubit>(context)
                  .setImprovements(property['id'], quantity);
            }));
      }
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              isMouseOver = true;
            });
          },
          onExit: (_) {
            setState(() {
              isMouseOver = false;
            });
          },
          child: Container(
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
                if (widget.property['isMortgaged'])
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
                if (isMouseOver && widget.showButtons)
                  Positioned.fill(
                    child: Container(
                      color: Colors.grey.withOpacity(0.45),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...propertyButtons.map(
                            (button) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: button,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
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

  int getNumImprovements(String status) {
    switch (status) {
      case 'NO_MONOPOLY':
        return 0;
      case 'MONOPOLY':
        return 0;
      case 'ONE_IMPROVEMENT':
        return 1;
      case 'TWO_IMPROVEMENTS':
        return 2;
      case 'THREE_IMPROVEMENTS':
        return 3;
      case 'FOUR_IMPROVEMENTS':
        return 4;
      case 'FIVE_IMPROVEMENTS':
        return 5;
      // Shouldn't get here, but just in case
      case _:
        return -1;
    }
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
