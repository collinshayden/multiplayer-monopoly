/// Author: Alex Hall
/// Date: 11/18/2023

import 'package:client/cubit/game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  bool _isExpanded = false;

  List<Widget> items = [
    EndpointCallButton(
      title: 'Load Local Config',
      endpointCallback: (context) {
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

/// Signature for endpoint callbacks used to create [EndpointCallButton]s.
typedef EndpointCallback = void Function(BuildContext context);

/// A button which can make calls to the endpoint.
class EndpointCallButton extends StatelessWidget {
  const EndpointCallButton({
    super.key,
    required this.title,
    required this.endpointCallback,
  });

  final String title;
  final EndpointCallback endpointCallback;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      // Passes `context` into given callback, allowing it to find the cubit
      onTap: () => endpointCallback(context),
    );
  }
}
