part of 'event_cubit.dart';

// ROOT EVENT STATE

/// Base class for all events used by all screens in the application.
///
/// This base state requires that all subclasses include a `super.event` formal
/// named parameter.
sealed class EventState {}

// BASE EVENT STATES

class _NullEvent extends EventState {}

class ShowEvent extends EventState {
  ShowEvent({required this.event});

  final Event event;
}

class PromptEvent extends EventState {
  PromptEvent({required this.event});

  final Event event;
}

// CONCRETE EVENT STATES

class ShowPlayerJoin extends ShowEvent {
  ShowPlayerJoin({required super.event});
}

class PromptStartGame extends PromptEvent {
  PromptStartGame({required super.event});
}

class ShowStartGame extends ShowEvent {
  ShowStartGame({required super.event});
}

class ShowStartTurn extends ShowEvent {
  ShowStartTurn({required super.event});
}

class ShowRoll extends ShowEvent {
  ShowRoll({required super.event});
}

class ShowPassGo extends ShowEvent {
  ShowPassGo({required super.event});
}

class ShowRent extends ShowEvent {
  ShowRent({required super.event});
}

class ShowTax extends ShowEvent {
  ShowTax({required super.event});
}

class ShowMovePlayer extends ShowEvent {
  ShowMovePlayer({required super.event});
}

class PromptPurchase extends PromptEvent {
  PromptPurchase({required super.event});
}

class ShowPurchase extends ShowEvent {
  ShowPurchase({required super.event});
}

class ShowImprovement extends ShowEvent {
  ShowImprovement({required super.event});
}

class ShowMortgage extends ShowEvent {
  ShowMortgage({required super.event});
}

class PromptEndTurn extends PromptEvent {
  PromptEndTurn({required super.event});
}

class ShowEndTurn extends ShowEvent {
  ShowEndTurn({required super.event});
}

class PromptLiquidate extends PromptEvent {
  PromptLiquidate({required super.event});
}

class ShowLoser extends ShowEvent {
  ShowLoser({required super.event});
}

class ShowEndGame extends ShowEvent {
  ShowEndGame({required super.event});
}

class ShowBankruptcy extends ShowEvent {
  ShowBankruptcy({required super.event});
}
