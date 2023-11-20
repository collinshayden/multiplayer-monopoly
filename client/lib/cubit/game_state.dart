part of 'game_cubit.dart';

/// Base class for all states which the game can be in.
///
/// Subclassing this base class requires that all relevant information to a
/// particular state subclass be included as a field therein.
///
/// Note: What we've been calling "game state" is now being referred to as "game
/// data", and the actual status of the game is being referred to as "game
/// state". The "state" of the game may be thought of as a state transition
/// graph which the game "traverses" throughout gameplay.
sealed class GameState {}

/// Empty initial state.
class GameInitial extends GameState {}

class SuccessState extends GameState {
  SuccessState({required this.game});
  final Game game;
}

class LoadingState extends GameState {}

class FailureState extends GameState {
  FailureState({required this.object});
  final dynamic object;
}

/// Loading in configuration from local files.
class LocalConfigLoading extends LoadingState {}

class LocalConfigSuccess extends SuccessState {
  LocalConfigSuccess({required super.game});
}

class LocalConfigFailure extends FailureState {
  LocalConfigFailure({required super.object});
}

/// Game state update emits
class GameStateUpdateLoading extends LoadingState {}

class GameStateUpdateSuccess extends SuccessState {
  GameStateUpdateSuccess({required super.game});
}

class GameStateUpdateFailure extends FailureState {
  GameStateUpdateFailure({required super.object});
}

class GameActionLoading extends LoadingState {}

class GameActionSuccess extends SuccessState {
  GameActionSuccess({required super.game});
}

class GameActionFailure extends FailureState {
  GameActionFailure({required super.object});
}

/// Establish a connection with the server.
class RemoteConfigLoading extends LoadingState {}

class RemoteConfigSuccess extends SuccessState {
  RemoteConfigSuccess({required super.game});
}

class RemoteConfigFailure extends FailureState {
  RemoteConfigFailure({required super.object});
}

class JoinGameLoading extends LoadingState {}

class JoinGameSuccess extends SuccessState {
  JoinGameSuccess({required super.game});
}

class JoinGameFailure extends FailureState {
  JoinGameFailure({required super.object});
}

class ActiveGame extends GameState {}

class ActiveTurnRollPhase extends GameState {}

class ActiveTurnUpkeepPhase extends GameState {}
