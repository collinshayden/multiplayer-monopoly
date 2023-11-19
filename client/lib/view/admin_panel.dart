import 'package:client/constants.dart';
import 'package:client/cubit/game_cubit.dart';
import 'package:client/view/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

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
    AdminButton(
      title: 'Update',
      onPressed: (context) {
        BlocProvider.of<GameCubit>(context).updateGameData(useAdmin: true);
      },
    ),
    AdminTextInput(
      title: 'Register Player',
      onPressed: (context, text) {
        BlocProvider.of<GameCubit>(context).registerPlayer(displayName: text);
      },
    ),
    AdminButton(
      title: 'Start Game',
      onPressed: (context) {
        BlocProvider.of<GameCubit>(context).startGame();
      },
    ),
    AdminButton(
      title: 'Roll Dice',
      onPressed: (context) {
        BlocProvider.of<GameCubit>(context).rollDice();
      },
    ),
    AdminButton(
      title: 'End Turn',
      onPressed: (context) {
        BlocProvider.of<GameCubit>(context).endTurn();
      },
    ),
    AdminButton(
      title: 'Reset Game',
      onPressed: (context) {
        BlocProvider.of<GameCubit>(context).resetGame();
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
        width: 500,
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

typedef ContextualTextInputCallback = void Function(
    BuildContext context, String text);

typedef ContextualNumberInputCallback = void Function(
    BuildContext context, int number);

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
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title),
        // Passes `context` into given callback, allowing it to find the GameCubit.
        onTap: () => onPressed(context),
        dense: true);
  }
}

class AdminTextInput extends StatefulWidget {
  const AdminTextInput({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final ContextualTextInputCallback onPressed;

  @override
  State<StatefulWidget> createState() => _AdminTextInputState();
}

class _AdminTextInputState extends State<AdminTextInput> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      trailing: Row(
        children: [
          Expanded(
            flex: 5,
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              splashRadius: 9,
              color: Colors.blue[600],
              icon: const Icon(Icons.send),
              onPressed: () {
                widget.onPressed(context, _controller?.text ?? '');
                _controller?.text = '';
              },
            ),
          ),
        ],
      ),
      dense: true,
    );
  }
}

class AdminTileValueShifter extends StatefulWidget {
  const AdminTileValueShifter({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final ContextualNumberInputCallback onPressed;

  @override
  State<AdminTileValueShifter> createState() => _AdminTileValueShifterState();
}

class _AdminTileValueShifterState extends State<AdminTileValueShifter> {
  var tileIds = List.generate(40, (index) => index);
  int selectedTileId = 0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // title: Text(widget.title),
      trailing: SizedBox(
        width: 120,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: DropdownButton(
                  items: tileIds.map((e) {
                    return DropdownMenuItem(value: e, child: Text('$e'));
                  }).toList(),
                  onChanged: (value) {
                    selectedTileId = value ?? 0;
                  }),
            ),
          ],
        ),
      ),
      dense: true,
    );
  }
}
