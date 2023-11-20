import 'package:client/constants.dart';
import 'package:client/cubit/game_cubit.dart';
import 'package:client/model/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

// DEFINE BUTTONS HERE!
class _AdminPanelState extends State<AdminPanel> {
  /// Whether the admin panel is currently open or not. By default, this widget
  /// will load unexpanded.
  bool _isExpanded = false;

  /// A list of widgets used to construct the admin panel.
  /// These will be positioned vertically in a column.
  List<Widget> items = [
    AdminButton(
      title: 'Load Local Config',
      onPressed: (gameCubit) {
        gameCubit.loadLocalConfig();
      },
    ),
    AdminButton(
      title: 'Update',
      onPressed: (gameCubit) {
        gameCubit.updateGameData(useAdmin: true);
      },
    ),
    AdminTextInput(
      title: 'Register Player',
      onPressed: (gameCubit, text) {
        gameCubit.registerPlayer(displayName: text);
      },
    ),
    const AdminClientSelector(title: 'Select Client'),
    AdminButton(
      title: 'Start Game',
      onPressed: (gameCubit) {
        gameCubit.startGame();
      },
    ),
    AdminButton(
      title: 'Roll Dice',
      onPressed: (gameCubit) {
        gameCubit.rollDice();
      },
    ),
    AdminTileButton(
      title: 'Buy Property',
      onPressed: (gameCubit, tileId) {
        gameCubit.buyProperty(tileId);
      },
    ),
    AdminImprovementsShifter(
      title: 'Set Improvements',
      onPressed: (gameCubit, tileId, number) {
        gameCubit.setImprovements(tileId, number);
      },
    ),
    AdminMortgageSetter(
      title: 'Set Mortgage',
      onPressed: (gameCubit, tileId, isMortgaged) {
        gameCubit.setMortgage(tileId, isMortgaged);
      },
    ),
    AdminJailButton(
        title: 'Jail Method',
        onPressed: (gameCubit, jailMethod) {
          gameCubit.getOutOfJail(jailMethod);
        }),
    AdminButton(
      title: 'End Turn',
      onPressed: (gameCubit) {
        gameCubit.endTurn();
      },
    ),
    AdminButton(
      title: 'Reset Game',
      onPressed: (gameCubit) {
        gameCubit.resetGame(useAdmin: true);
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

/// Signature for callbacks used to create [AdminButton]s. Callbacks which are
/// assigned through this type will be called with a [GameCubit] object such
/// that methods may be easily called on it.
typedef CubitCallback = void Function(GameCubit cubit);

/// Signature for callbacks used to create [AdminTextInput]s. Callbacks which
/// are assigned through this type will be cakked with a [GameCubit] object and
/// text representing the input currently in the [AdminTextInput].
typedef TextInputCubitCallback = void Function(GameCubit cubit, String text);

typedef TileValueSetterCubitCallback<T> = void Function(
    GameCubit cubit, int tileId, T value);

typedef TileCubitCallback = void Function(GameCubit cubit, int tileId);

typedef JailCubitCallback = void Function(
    GameCubit cubit, JailMethod jailMethod);

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
  final CubitCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title),
        // Find and pass the Cubit to the callback.
        onTap: () {
          final gameCubit = BlocProvider.of<GameCubit>(context);
          onPressed(gameCubit);
        },
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
  final TextInputCubitCallback onPressed;

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
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      trailing: SizedBox(
        width: 150,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                splashRadius: 20,
                color: Colors.blue[600],
                icon: const Icon(Icons.send),
                onPressed: () {
                  final gameCubit = BlocProvider.of<GameCubit>(context);
                  widget.onPressed(gameCubit, _controller?.text ?? '');
                  _controller?.text = '';
                },
              ),
            ),
          ],
        ),
      ),
      dense: true,
    );
  }
}

class AdminClientSelector extends StatefulWidget {
  const AdminClientSelector({super.key, required this.title});

  final String title;

  @override
  State<AdminClientSelector> createState() => _AdminClientSelectorState();
}

class _AdminClientSelectorState extends State<AdminClientSelector> {
  PlayerId? selectedClientId;

  @override
  Widget build(BuildContext context) {
    var playerList = BlocProvider.of<GameCubit>(context).game.players;
    return BlocBuilder<GameCubit, GameState>(
        builder: (innerContext, gameState) {
      return ListTile(
        title: Text(widget.title),
        trailing: SizedBox(
          width: 150,
          child: Row(
            children: [
              DropdownButton(
                isDense: true,
                hint: Text(playerList[selectedClientId]?.displayName ?? 'None'),
                items: playerList.keys
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text('${playerList[e]?.displayName}'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedClientId = value;
                  });
                },
              ),
              IconButton(
                splashRadius: 20,
                color: Colors.blue[600],
                icon: const Icon(Icons.send),
                onPressed: () {
                  final gameCubit = BlocProvider.of<GameCubit>(context);
                  if (selectedClientId != null) {
                    gameCubit.switchActivePlayerId(selectedClientId!);
                  }
                },
              ),
            ],
          ),
        ),
        dense: true,
      );
    });
  }
}

class AdminTileButton extends StatefulWidget {
  const AdminTileButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final TileCubitCallback onPressed;

  @override
  State<AdminTileButton> createState() => _AdminTileButtonState();
}

class _AdminTileButtonState extends State<AdminTileButton> {
  var tileIds = List.generate(40, (index) => index);
  int selectedTileId = 0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      trailing: SizedBox(
        width: 150,
        child: Row(
          children: [
            DropdownButton(
              isDense: true,
              hint: Text('Tile: $selectedTileId'),
              items: tileIds
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedTileId = value ?? 0;
                });
              },
            ),
            IconButton(
              splashRadius: 20,
              color: Colors.blue[600],
              icon: const Icon(Icons.send),
              onPressed: () {
                final gameCubit = BlocProvider.of<GameCubit>(context);
                widget.onPressed(gameCubit, selectedTileId);
              },
            ),
          ],
        ),
      ),
      dense: true,
    );
  }
}

class AdminImprovementsShifter extends StatefulWidget {
  const AdminImprovementsShifter({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final TileValueSetterCubitCallback<int> onPressed;

  @override
  State<AdminImprovementsShifter> createState() =>
      _AdminImprovementsShifterState();
}

class _AdminImprovementsShifterState extends State<AdminImprovementsShifter> {
  var tileIds = List.generate(40, (index) => index);
  var improvementValues = List.generate(6, (index) => index);
  int selectedTileId = 0;
  int tileValue = 0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      trailing: SizedBox(
        width: 150,
        child: Row(
          children: [
            DropdownButton(
              isDense: true,
              hint: Text('Tile: $selectedTileId'),
              items: tileIds
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedTileId = value ?? 0;
                });
              },
            ),
            DropdownButton(
              isDense: true,
              hint: Text('$tileValue'),
              items: improvementValues
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  tileValue = value ?? tileValue;
                });
              },
            ),
            IconButton(
              splashRadius: 20,
              color: Colors.blue[600],
              icon: const Icon(Icons.send),
              onPressed: () {
                final gameCubit = BlocProvider.of<GameCubit>(context);
                widget.onPressed(gameCubit, selectedTileId, tileValue);
              },
            ),
          ],
        ),
      ),
      dense: true,
    );
  }
}

class AdminMortgageSetter extends StatefulWidget {
  const AdminMortgageSetter({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final TileValueSetterCubitCallback<bool> onPressed;

  @override
  State<AdminMortgageSetter> createState() => _AdminMortgageSetterState();
}

class _AdminMortgageSetterState extends State<AdminMortgageSetter> {
  List<int> tileIds = [];
  int selectedTileId = 0;
  bool selectedMortgage = false;

  @override
  Widget build(BuildContext context) {
    tileIds = BlocProvider.of<GameCubit>(context).getMortgageableTileIds();
    return ListTile(
      title: Text(widget.title),
      trailing: SizedBox(
        width: 150,
        child: Row(
          children: [
            DropdownButton(
              isDense: true,
              hint: Text('Tile: $selectedTileId'),
              items: tileIds
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedTileId = value ?? 0;
                });
              },
            ),
            DropdownButton(
              alignment: AlignmentDirectional.centerEnd,
              isDense: true,
              items: [false, true]
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedMortgage = value ?? selectedMortgage;
                });
              },
            ),
            IconButton(
              splashRadius: 20,
              color: Colors.blue[600],
              icon: const Icon(Icons.send),
              onPressed: () {
                final gameCubit = BlocProvider.of<GameCubit>(context);
                widget.onPressed(gameCubit, selectedTileId, selectedMortgage);
              },
            ),
          ],
        ),
      ),
      dense: true,
    );
  }
}

class AdminJailButton extends StatefulWidget {
  const AdminJailButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final JailCubitCallback onPressed;

  @override
  State<AdminJailButton> createState() => _AdminJailButtonState();
}

class _AdminJailButtonState extends State<AdminJailButton> {
  JailMethod? selectedMethod;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      trailing: SizedBox(
        width: 150,
        child: Row(
          children: [
            DropdownButton(
              isDense: true,
              hint: Text('Tile: ${selectedMethod ?? 'None'}'),
              items: JailMethod.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                });
              },
            ),
            IconButton(
              splashRadius: 20,
              color: Colors.blue[600],
              icon: const Icon(Icons.send),
              onPressed: () {
                if (selectedMethod != null) {
                  final gameCubit = BlocProvider.of<GameCubit>(context);
                  widget.onPressed(gameCubit, selectedMethod!);
                }
              },
            ),
          ],
        ),
      ),
      dense: true,
    );
  }
}
