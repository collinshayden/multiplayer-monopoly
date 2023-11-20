/// File containing the classes for viewing/editing properties.
/// Author: Jordan Bourdeau
/// Date: 11/20/2023

import 'package:client/cubit/game_cubit.dart';
import 'package:client/model/asset_enums.dart';
import 'package:flutter/material.dart';
import 'package:client/model/player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PropertyInfo extends StatelessWidget {
  final Map<String, dynamic> property;

  PropertyInfo({
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              property['name'] ?? 'Unknown Property',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Price: \$${property['price'] ?? 0}',
              style: TextStyle(fontSize: 16),
            ),
            if (property.containsKey('rent')) ...[
              SizedBox(height: 8),
              Text(
                'Rent: \$${property['rent'] ?? 0}',
                style: TextStyle(fontSize: 16),
              ),
            ],
            if (property.containsKey('improvementCost')) ...[
              SizedBox(height: 8),
              Text(
                'Improvement Cost: \$${property['improvementCost'] ?? 0}',
                style: TextStyle(fontSize: 16),
              ),
            ],
            SizedBox(height: 8),
            // Not relevant
            // Text(
            //   'Owner: ${property['owner'] ?? 'Unowned'}',
            //   style: TextStyle(fontSize: 16),
            // ),
            // SizedBox(height: 8),
            Text(
              'Status: ${property['status'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 16),
            ),
            if (property.containsKey('isMortgaged')) ...[
              SizedBox(height: 8),
              Text(
                'Mortgaged: ${property['isMortgaged'] ?? false}',
                style: TextStyle(fontSize: 16),
              ),
            ],
            if (property.containsKey('mortgagePrice')) ...[
              SizedBox(height: 8),
              Text(
                'Mortgage Price: \$${property['mortgagePrice'] ?? 0}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PropertyList extends StatelessWidget {
  final List<Map<String, dynamic>> assets;

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

    return Container(
      // Wrap with a Container
      height: MediaQuery.of(context)
          .size
          .height, // Set a fixed height or adjust as needed
      child: ListView.builder(
        itemCount: groupedProperties.length,
        itemBuilder: (context, index) {
          String group = groupedProperties.keys.elementAt(index);
          List<Map<String, dynamic>> properties = groupedProperties[group]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Group: $group',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                children: properties
                    .map((property) => PropertyInfo(property: property))
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
