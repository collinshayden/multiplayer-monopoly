part of 'game_cubit.dart';

/// Base class for all states which the game can be in.
/// Subclassing this base class requires that all relevant information to a
/// particular state subclass be included as a field therein.
/// Note: What we've been calling "game state" is now being referred to as "game
/// data", and the actual status of the game is being referred to as "game
/// state".
sealed class GameState {}

/// Empty initial state.
class GameInitial extends GameState {}

/// Loading in configuration from local files.
class LocalConfigLoading extends GameState {}

class LocalConfigSuccess extends GameState {
  LocalConfigSuccess({required this.game});

  final Game game;
}

class LocalConfigFailure extends GameState {
  LocalConfigFailure([this.object]);

  final dynamic object;
}

/// Game state update emits
class GameStateUpdateSuccess extends GameState {}

class GameStateUpdateFailure extends GameState {}

/// Establish a connection with the server.
class RemoteConfigLoading extends GameState {}

class RemoteConfigSuccess extends GameState {}

class RemoteConfigFailure extends GameState {}

class JoinGameLoading extends GameState {}

class JoinGameSuccess extends GameState {}

class JoinGameFailure extends GameState {}

class ActiveGame extends GameState {}

class ActiveTurnRollPhase extends GameState {}

class ActiveTurnUpkeepPhase extends GameState {}

class OffTurn extends GameState {}

class GameErrorState extends GameState {}
