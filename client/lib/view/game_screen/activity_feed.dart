import 'package:flutter/material.dart';
import 'package:client/cubit/event_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayActivityFeed extends StatelessWidget {
  final List<String> activityList;

  const DisplayActivityFeed({required this.activityList});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: activityList.length,
        itemBuilder: (context, index) {
          final item = activityList[index];
          return ListTile(
            title: Center(child: Text(item)),
          );
        },
      ),
    );
  }
}

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  final Set<String> _uniqueMessages = {}; // Set to store unique event messages
  final List<String> _activityList = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventState>(
      buildWhen: (previous, current) {
        return current is ShowRoll ||
            current is ShowPlayerJoin ||
            // TODO Add other event checks as needed
            current is ShowBankruptcy;
      },
      builder: (context, state) {
        _processState(state);
        return Padding(
          padding: const EdgeInsets.only(top: 300),
          child: DisplayActivityFeed(activityList: _activityList),
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
    } else if (state is ShowPlayerJoin) {
      final displayName = state.event.parameters["displayName"];
      _addItem("$displayName has joined the game!");
    }
    // Handle other states similarly if needed
  }

  void _addItem(String content) {
    if (!_uniqueMessages.contains(content)) {
      _uniqueMessages.add(content);
      Future.microtask(() {
        setState(() {
          _activityList.insert(0, content);
          if (_activityList.length > 5) {
            _activityList.removeLast();
          }
        });
      });
    }
  }
}
