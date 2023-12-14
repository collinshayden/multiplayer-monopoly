import 'package:flutter/material.dart';
import 'package:client/cubit/event_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayActivityFeed extends StatelessWidget {
  final List<String> activityList;

  const DisplayActivityFeed({Key? key, required this.activityList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: activityList.length,
        itemBuilder: (context, index) {
          final item = activityList[index];
          // Calculate opacity based on the item's position
          final opacity = 1.0 - (index / activityList.length);

          return AnimatedOpacity(
            opacity: opacity,
            duration: const Duration(seconds: 1), 
            child: ListTile(
              title: Center(
                child: Text(item),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ActivityFeed extends StatefulWidget {
  const ActivityFeed({Key? key}) : super(key: key);

  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  final List<String> _activityList = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventState>(
      buildWhen: (previous, current) {
        return current is ShowRoll ||
            current is ShowStartTurn ||
            current is ShowTax ||
            current is ShowStartGame ||
            current is ShowPassGo ||
            current is ShowRent ||
            current is ShowPurchase ||
            current is ShowImprovement ||
            current is ShowEndGame ||
            current is ShowBankruptcy;
      },
      builder: (context, state) {
        return _buildActivityFeed(context, state);
      },
    );
  }

  Widget _buildActivityFeed(BuildContext context, EventState state) {
    _processState(state);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: EdgeInsets.only(top: constraints.maxHeight / 2.5),
          child: DisplayActivityFeed(activityList: _activityList.toList()),
        );
      },
    );
  }

  void _processState(EventState state) {
    if (state is ShowRoll) {
      final displayName = state.event.parameters["displayName"];
      final first = state.event.parameters['first'];
      final second = state.event.parameters['second'];
      _addItem("$displayName has rolled ${first + second}!");
    } else if (state is ShowStartGame) {
      _addItem("The game has started.");
    } else if (state is ShowStartTurn) {
      final displayName = state.event.parameters["displayName"];
      _addItem("$displayName's turn has started.");
    } else if (state is ShowPassGo) {
      final displayName = state.event.parameters["displayName"];
      // _addItem("$displayName has passed Go and recieved \$200.");
    } else if (state is ShowRent) {
      final activePlayerName = state.event.parameters["activePlayerName"];
      final landlordName = state.event.parameters["landlordName"];
      final amount = state.event.parameters["amount"];
      _addItem(
          "$activePlayerName has landed on $landlordName's property and pays \$$amount");
    } else if (state is ShowPurchase) {
      final displayName = state.event.parameters["displayName"];
      final propertyName = state.event.parameters["propertyName"];
      _addItem("$displayName purchased $propertyName.");
    } else if (state is ShowImprovement) {
      final displayName = state.event.parameters["displayName"];
      final propertyName = state.event.parameters["propertyName"];
      final changeInImprovements =
          state.event.parameters["changeInImprovements"];
      if (changeInImprovements == -1) {
        _addItem("$displayName sold an improvement on $propertyName.");
      } else {
        _addItem("$displayName bought an improvement on $propertyName.");
      }
    } else if (state is ShowTax) {
      final displayName = state.event.parameters["displayName"];
      final amount = (state.event.parameters["amount"] as int) * -1;
      _addItem("$displayName pays \$$amount in taxes.");
    } else if (state is ShowBankruptcy) {
      final displayName = state.event.parameters["displayName"];
      _addItem("$displayName has gone bankrupt.");
    } else if (state is ShowEndGame) {
      final winnerName = state.event.parameters["winnerName"];
      _addItem("The game has ended. $winnerName wins!");
    }
  }

  void _addItem(String content) {
    _activityList.insert(0, content);
    if (_activityList.length > 5) {
      _activityList.removeLast();
    }
  }
}
