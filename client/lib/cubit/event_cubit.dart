import 'dart:async';
import 'dart:collection';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/cubit/game_cubit.dart';
import 'package:client/model/events.dart';

part 'event_state.dart';

/// A [Cubit] which dispatches incoming event queues to the application.
///
/// This object's lifecycle consists of three parts:
/// 1. Initialisation: The Cubit receives a reference to the [GameCubit] and
/// explicitly sets up a [StreamSubscription] to listen for [EventEnqueuement]
/// state emissions.
/// 2. Work: Whenever new [EventEnqueuement] states are received, this object
/// will process them in order. The events contained in
/// [EventEnqueuement.events] are passed to [_flushEvents], which dequeues and
/// dispatches events in order. As each event is dequeued, a new state may be
/// emitted as a result
/// 3. Closing: Whenever the framework calls [close] on this object, it will
/// cancel the subscription to the [GameCubit]'s [EventEnqueuement] states.
class EventCubit extends Cubit<EventState> {
  EventCubit({required GameCubit gameCubit}) : super(InitialEvent()) {
    // Add a single listener for events from the GameCubit
    _eventSubscription = gameCubit.stream.listen((state) async {
      if (state is EventEnqueuement) {
        await _flushEvents(state.events);
      }
    });
  }

  late StreamSubscription _eventSubscription;

  @override
  Future<void> close() async {
    _eventSubscription.cancel();
    await super.close();
  }

  Future<void> _flushEvents(List<Event> events) async {
    while (events.isNotEmpty) {
      // Get next event in queue
      Event event = events.removeAt(0);
      // Emit the correct event, if it is not null
      if (event.type == null) continue;
      // TODO: Insert any blocking logic needed to control event flow through emits.
      // TODO: Simplify this...
      switch (event.type!) {
        case EventType.showPlayerJoin:
          emit(ShowPlayerJoin(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.promptStartGame:
          emit(PromptStartGame(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.showStartGame:
          emit(ShowStartGame(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.showStartTurn:
          emit(ShowStartTurn(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.showRoll:
          emit(ShowRoll(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.showPassGo:
          emit(ShowPassGo(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.showRent:
          emit(ShowRent(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.showTax:
          emit(ShowTax(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.showMovePlayer:
          emit(ShowMovePlayer(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.promptPurchase:
          emit(PromptPurchase(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.showPurchase:
          emit(ShowPurchase(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.showImprovement:
          emit(ShowImprovement(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.showMortgage:
          emit(ShowMortgage(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.promptEndTurn:
          emit(PromptEndTurn(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.showEndTurn:
          emit(ShowEndTurn(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.promptLiquidate:
          emit(PromptLiquidate(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.showLoser:
          emit(ShowLoser(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.showEndGame:
          emit(ShowEndGame(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
        case EventType.showBankruptcy:
          emit(ShowBankruptcy(event: event));
          await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }
}
