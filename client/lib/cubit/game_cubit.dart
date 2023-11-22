import 'dart:async';
import 'dart:collection';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/constants.dart'; // TODO: as Constants? (stackoverflow.com/questions/54069239)
import 'package:client/model/events.dart';
import 'package:client/model/game.dart';
import 'package:client/model/player.dart';
import 'package:client/json_utils.dart';
import 'endpoint_service.dart';
import 'file_service.dart';
import 'event_cubit.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit({
    required this.game,
    required this.fileService,
    required this.endpointService,
  }) : super(GameInitial()) {
    _startTimer();
  }

  // Initialise game
  final Game game;

  // A unique identifier assigned
  PlayerId? clientPlayerId;

  // Initialise services
  final FileService fileService;
  final EndpointService endpointService;

  bool _hasLoadedLocalConfig = false;

  // A timer used to perform polling asynchronously.
  late Timer _timer;

  /// A setup function used to configure and start polling.
  ///
  /// This function uses the [POLL_PERIOD] application constant to decide how
  /// often to call [updateGameData], and will pass in `useAdmin: true` whenever
  /// [clientPlayerId] is not set.
  ///
  /// TODO: Fix useAdmin parameter.
  void _startTimer() {
    _timer = Timer.periodic(
      POLL_PERIOD,
      (timer) async {
        // print('updated state');
        if (clientPlayerId != null) {
          updateGameData();
        } else {
          updateGameData(useAdmin: true);
        }
      },
    );
  }

  /// Dispose of this Cubit's resources.
  ///
  /// This function simply cancels the polling [Timer] object and makes a call
  /// to [BlocBase.close].
  @override
  Future<void> close() async {
    _timer.cancel();
    await super.close();
  }

  /// Load local configuration files and emit the result.
  ///
  /// This function loads local configuration from persistent memory stored as
  /// JSON. A [LocalConfigLoading] state is always emitted, and then either a
  /// [LocalConfigFailure] or [LocalConfigSuccess] will emitted dependent on
  /// whether the config was able to be loaded by the file service and
  /// deserialised into a [Game] object.
  ///
  /// This method only needs to be called once at the beginning of the game.
  Future<void> loadLocalConfig() async {
    emit(LocalConfigLoading());
    await Future.delayed(const Duration(milliseconds: 250)); // TODO: Remove
    emit(LocalConfigLoading());

    late Json? localConfig;
    try {
      localConfig = await fileService.getLocalConfig();
      game.applyJson(localConfig);
    } catch (e) {
      emit(LocalConfigFailure(object: e));
    }

    _hasLoadedLocalConfig = true;
    emit(LocalConfigSuccess(game: game));
  }

  /// Retrieve game data from the server.
  ///
  /// This method serves as an entry point for all data from the server. Beyond
  /// a simple success status [bool], all other methods call endpoints return no
  /// information about the current game's state.
  ///
  /// This method dispatches the list (queue) of incoming events to the
  /// [EventCubit] through the [EventEnqueuement] state. The incoming JSON, if
  /// it contains an `events` key, is translated into a Queue to be passed to
  /// the [EventCubit]. The sole consumer of this state is the [EventCubit], and
  /// thus all inter-Cubit communication about new events should go through this
  /// state emission.
  Future<void> updateGameData({useAdmin = false}) async {
    assert(_hasLoadedLocalConfig);
    emit(GameStateUpdateLoading());

    var playerId = useAdmin ? PlayerId('admin') : clientPlayerId;
    Json? gameData;
    try {
      gameData = await endpointService.fetchData(playerId: playerId!);
      game.applyJson(gameData);
      // Check whether any new events have arrived.
      if (gameData.containsKey('events') &&
          (gameData['events'] is List) &&
          (gameData['events'] as List).isNotEmpty) {
        // JSON translation into a Queue object
        final Queue<Event> events = (gameData['events'] as List)
            .map((e) => Event.fromJson(e))
            .toList() as Queue<Event>;
        emit(EventEnqueuement(events: events));
      }
      emit(GameStateUpdateSuccess(game: game));
    } catch (e) {
      emit(GameStateUpdateFailure(object: e));
    }
  }

  /// Method to get the location of the active player.
  int? getActivePlayerLocation() {
    return game.getPlayerLocation(clientPlayerId!);
  }

  /// Request to join the active game session.
  ///
  /// This function calls the server's `register_player` endpoint with the user-
  /// inputted [displayName]. This function will only be successful if the
  /// game has not yet started. Because there is currently only one instance of
  /// the game running at a time, it is necessary to call [reset] to be able to
  /// join a game.
  Future<void> registerPlayer({required String displayName}) async {
    emit(JoinGameLoading());
    try {
      final playerId =
          await endpointService.registerPlayer(displayName: displayName);
      // Set the activte player to be what is returned from register_player.
      clientPlayerId = playerId;
      emit(JoinGameSuccess(game: game));
    } catch (e) {
      emit(JoinGameFailure(object: e));
    }
  }

  /// Roll dice during a player's active turn.
  ///
  /// The client should only be able to call this
  Future<void> rollDice() async {
    emit(GameActionLoading());
    try {
      await endpointService.rollDice(clientPlayerId!);
      emit(GameActionSuccess(game: game));
    } catch (e) {
      emit(GameActionFailure(object: e));
    }
  }

  /// End a player's turn.
  ///
  /// The client should only be able to call this
  Future<void> endTurn() async {
    emit(GameActionLoading());
    try {
      await endpointService.endTurn(clientPlayerId!);
      emit(GameActionSuccess(game: game));
    } catch (e) {
      emit(GameActionFailure(object: e));
    }
    // emit(ActiveTurnRollPhase());
  }

  Future<void> startGame() async {
    emit(GameActionLoading());
    try {
      await endpointService.startGame(playerId: clientPlayerId!);
      emit(GameActionSuccess(game: game));
    } catch (e) {
      emit(GameActionFailure(object: e));
    }
  }

  // Hardcoded to use admin ID for now
  Future<void> resetGame({bool useAdmin = false}) async {
    PlayerId playerId;
    if (useAdmin) {
      playerId = PlayerId('admin');
    } else {
      playerId = clientPlayerId!;
    }
    emit(GameActionLoading());
    try {
      await endpointService.reset(playerId: playerId);
      emit(GameActionSuccess(game: game));
    } catch (e) {
      emit(GameActionFailure(object: e));
    }
  }

  Future<void> buyProperty() async {
    emit(GameActionLoading());
    final int tileId = game.players[clientPlayerId]!.location!;
    try {
      await endpointService.buyProperty(clientPlayerId!, tileId);
      emit(GameActionSuccess(game: game));
    } catch (e) {
      emit(GameActionFailure(object: e));
    }
  }

  Future<void> setImprovements(int tileId, int quantity) async {
    emit(GameActionLoading());
    try {
      await endpointService.setImprovements(clientPlayerId!, tileId, quantity);
      emit(GameActionSuccess(game: game));
    } catch (e) {
      emit(GameActionFailure(object: e));
    }
  }

  Future<void> setMortgage(int tileId, bool mortgage) async {
    emit(GameActionLoading());
    try {
      await endpointService.setMortgage(clientPlayerId!, tileId, mortgage);
      emit(GameActionSuccess(game: game));
    } catch (e) {
      emit(GameActionFailure(object: e));
    }
  }

  Future<void> getOutOfJail(JailMethod jailMethod) async {
    emit(GameActionLoading());
    try {
      await endpointService.getOutOfJail(clientPlayerId!, jailMethod);
      emit(GameActionSuccess(game: game));
    } catch (e) {
      emit(GameActionFailure(object: e));
    }
  }

  /// Method used in the admin buttons to change the clientPlayerId to the
  /// Game object's active player ID. Allows you to simulate multiple users.
  void switchToActivePlayerId() {
    clientPlayerId = game.activePlayerId!;
  }
}
