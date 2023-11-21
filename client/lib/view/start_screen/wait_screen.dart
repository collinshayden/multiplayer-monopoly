import 'package:client/model/player.dart';
import 'package:flutter/material.dart';
import 'package:client/view/widgets.dart';
import 'package:client/view/game_screen/board.dart';
import 'package:client/view/game_screen/game_screen.dart';
import 'package:client/cubit/game_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaitScreen extends StatelessWidget {
  const WaitScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(BlocProvider.of<GameCubit>(context).game.players.length.toString())
          ],
        ),
      ),
    );
  }
}

// class PlayerDisplay extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<GameCubit, GameState>(
//       builder: (context, state) {
//         return PlayerInfoScreens(
//           players:
//               BlocProvider.of<GameCubit>(context).game.players.values.toList(),
//         );
//       },
//     );
//   }
// }

// class PlayerInfoScreens extends StatelessWidget {
//   final List<Player> players;
//   final Key? key;

//   PlayerInfoScreens({
//     required this.players,
//     this.key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Players'),
//       ),
//       body: ListView.builder(
//         itemCount: players.length,
//         itemBuilder: (context, index) {
//           return PlayerInfoExpansionTile(
//             player: players[index],
//           );
//         },
//       ),
//     );
//   }
// }

// class PlayerInfoExpansionTile extends StatefulWidget {
//   final Player player;

//   PlayerInfoExpansionTile({
//     required this.player,
//   });

//   @override
//   _PlayerInfoExpansionTileState createState() =>
//       _PlayerInfoExpansionTileState();
// }

// class _PlayerInfoExpansionTileState extends State<PlayerInfoExpansionTile> {
//   bool isPropertiesExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     final isClientPlayer =
//         widget.player.id == BlocProvider.of<GameCubit>(context).clientPlayerId;
//     final isActivePlayer = widget.player.id ==
//         BlocProvider.of<GameCubit>(context).game.activePlayerId;

//     return Row(
//       children: [
//         // Player Information Column
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ExpansionTile(
//                   title: _buildTitle(
//                     isClientPlayer,
//                     isActivePlayer,
//                     widget.player.displayName ?? 'N/A',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTitle(
//       bool isClientPlayer, bool isActivePlayer, String displayName) {
//     return Row(
//       children: [
//         if (isActivePlayer) ...[
//           const Icon(Icons.arrow_forward, color: Colors.black),
//           SizedBox(width: 4),
//         ],
//         if (isClientPlayer) ...[
//           const Icon(Icons.star, color: Colors.amber),
//           SizedBox(width: 4),
//         ],
//         Text(displayName),
//       ],
//     );
//   }
// }
