part of 'event_cubit.dart';

// ROOT EVENT STATE

sealed class EventState {}

// BASE EVENT STATES

class NullEvent extends EventState {}

class ShowEvent extends EventState {}

class PromptEvent extends EventState {}

// CONCRETE EVENT STATES

class ShowPlayerJoin extends ShowEvent {}

class PromptStartGame extends PromptEvent {}

class ShowStartGame extends ShowEvent {}

class ShowStartTurn extends ShowEvent {}

class ShowRoll extends ShowEvent {}

class ShowPassGo extends ShowEvent {}

class ShowRent extends ShowEvent {}

class ShowTax extends ShowEvent {}

class ShowMovePlayer extends ShowEvent {}

class PromptPurchase extends PromptEvent {}

class ShowPurchase extends ShowEvent {}

class ShowImprovement extends ShowEvent {}

class ShowMortgage extends ShowEvent {}

class PromptEndTurn extends PromptEvent {}

class ShowEndTurn extends ShowEvent {}

class PromptLiquidate extends PromptEvent {}

class ShowLoser extends ShowEvent {}

class ShowEndGame extends ShowEvent {}

class ShowBankruptcy extends ShowEvent {}
