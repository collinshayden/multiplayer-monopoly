/// Author: Alex Hall
/// Date: 11/18/2023

import 'package:client/cubit/game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget which creates the admin panel.
class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

/// Builds the admin panel and handles interactions.
class _AdminPanelState extends State<AdminPanel> {
  /// Whether the admin panel is currently open or not.
  bool _isExpanded = false;

  /// A list of widgets used to construct the admin panel.
  /// These will be positioned vertically in a column.
  List<Widget> items = [
    AdminButton(
      title: 'Load Local Config',
      onPressed: (context) {
        BlocProvider.of<GameCubit>(context).loadLocalConfig();
      },
    ),
  ];

  ExpansionPanelList _buildPanel() {
    return ExpansionPanelList(
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpanded = isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          backgroundColor: Colors.blue[100],
          headerBuilder: (BuildContext context, isExpanded) {
            return const ListTile(
              leading: Icon(Icons.developer_board),
              title: Text('Admin Panel'),
            );
          },
          body: Column(
            children: items.map((item) {
              return ListTile(title: item);
            }).toList(),
          ),
          isExpanded: _isExpanded,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topRight,
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildPanel(),
        ),
      ),
    );
  }
}

/// Signature for callbacks used to create [AdminButtons]s. Callbacks which are
/// assigned through this callback will be called with a [BuildContext] object
/// and can thus access any inherited Bloc/Cubit objects, as well as anything
/// else normally accessed through a `.of(context)` call.
typedef ContextualCallback = void Function(BuildContext context);

/// A button used in the [AdminPanel] widget.
///
/// This is one of a number of possible tools which can be included in the list
/// of tools provided by the [AdminPanel]. This button takes a
/// [ContextualCallback] and constructs a button wired to it.
class AdminButton extends StatelessWidget {
  const AdminButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final ContextualCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      // Passes `context` into given callback, allowing it to find the GameCubit.
      onTap: () => onPressed(context),
    );
  }
}
