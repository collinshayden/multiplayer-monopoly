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
  LocalConfigSuccess({required this.boardJson});

  final Map<String, dynamic> boardJson;
}

class LocalConfigFailure extends GameState {
  LocalConfigFailure([this.object]);

  final dynamic object;
}

/// Establish a connection with the server.
class EndpointLoading extends GameState {}

class EndpointSuccess extends GameState {}

class EndpointFailure extends GameState {}

/// Attempt to register a new player with an active session.
class JoinGameLoading extends GameState {}

class JoinGameSuccess extends GameState {}

class JoinGameFailure extends GameState {}

/// Most frequently used states for the game.
class ActiveTurn extends GameState {}

class InctiveTurn extends GameState {}

/// Transient states used only when the client requests an actions.
class ActionRequesting extends GameState {}

class ActionRejected extends GameState {}

class ActionAccepted extends GameState {}
