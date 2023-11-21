import 'dart:async';
import 'dart:collection';

import 'package:client/cubit/game_cubit.dart';
import 'package:client/model/events.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit({required GameCubit gameCubit})
      : eventQueue = Queue(),
        super(_NullEvent()) {
    // Add a single listener for events from the GameCubit
    gameSubscription = gameCubit.stream.listen((gameState) async {
      if (gameState is EventEnqueuement) {
        // List[C, D, E] -> Queue[A, B] = Queue[A, B, C, D, E]
        eventQueue.addAll(gameState.events);
        flush();
      }
    });
  }

  late StreamSubscription gameSubscription;
  final Queue eventQueue;

  Future<void> flush() async {
    while (eventQueue.isNotEmpty) {
      // Get next event in queue
      Event event = eventQueue.removeFirst();
      // Emit the correct event, if it is not null
      if (event.type == null) continue;
      // TODO: Insert any blocking logic needed to control event flow through emits.
      switch (event.type!) {
        case EventType.showPlayerJoin:
          emit(ShowPlayerJoin(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.promptStartGame:
          emit(PromptStartGame(event: event));
        case EventType.showStartGame:
          emit(ShowStartGame(event: event));
        case EventType.showStartTurn:
          emit(ShowStartTurn(event: event));
        case EventType.showRoll:
          emit(ShowRoll(event: event));
        case EventType.showPassGo:
          emit(ShowPassGo(event: event));
        case EventType.showRent:
          emit(ShowRent(event: event));
        case EventType.showTax:
          emit(ShowTax(event: event));
        case EventType.showMovePlayer:
          emit(ShowMovePlayer(event: event));
        case EventType.promptPurchase:
          emit(PromptPurchase(event: event));
        case EventType.showPurchase:
          emit(ShowPurchase(event: event));
        case EventType.showImprovement:
          emit(ShowImprovement(event: event));
        case EventType.showMortgage:
          emit(ShowMortgage(event: event));
        case EventType.promptEndTurn:
          emit(PromptEndTurn(event: event));
        case EventType.showEndTurn:
          emit(ShowEndTurn(event: event));
        case EventType.promptLiquidate:
          emit(PromptLiquidate(event: event));
        case EventType.showLoser:
          emit(ShowLoser(event: event));
        case EventType.showEndGame:
          emit(ShowEndGame(event: event));
        case EventType.showBankruptcy:
          emit(ShowBankruptcy(event: event));
      }
    }
  }
}
