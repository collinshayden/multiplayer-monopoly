import 'dart:collection';

import 'package:client/model/events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/constants.dart';
import 'package:client/model/game.dart';
import 'package:client/model/player.dart';
import 'package:client/cubit/file_service.dart';
import 'package:client/cubit/endpoint_service.dart';
import 'package:client/json_utils.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit({
    required this.game,
    required this.fileService,
    required this.endpointService,
  }) : super(GameInitial());

  // Initialise game
  final Game game;

  // A unique identifier assigned
  PlayerId? clientPlayerId;

  // Initialise services
  final FileService fileService;
  final EndpointService endpointService;

  /// Load local configuration files and emit the result.
  ///
  /// This function loads local configuration from persistent memory stored as
  /// JSON. A [LocalConfigLoading] state is always emitted, and then either a
  /// [LocalConfigFailure] or [LocalConfigSuccess] will emitted dependent on
  /// whether the config was able to be loaded by the file service and
  /// deserialised into a [Game] object.
  void loadLocalConfig() async {
    emit(LocalConfigLoading());
    await Future.delayed(const Duration(milliseconds: 250)); // TODO: Remove
    late Json? localConfig;
    try {
      localConfig = await fileService.getLocalConfig();
      game.applyJson(localConfig);
    } catch (e) {
      emit(LocalConfigFailure(object: e));
    }

    emit(LocalConfigSuccess(game: game));
  }

  void updateGameData({useAdmin = false}) async {
    emit(GameStateUpdateLoading());
    late Json? gameData;
    var playerId = clientPlayerId;
    if (useAdmin) {
      playerId = PlayerId('admin');
    }
    try {
      gameData = await endpointService.fetchData(playerId: playerId!);
      game.applyJson(gameData);
      emit(GameStateUpdateSuccess(game: game));
    } catch (e) {
      emit(GameStateUpdateFailure(object: e));
    }
  }

  /// Load remote config from the server and emit the result.
  ///
  /// This function is currently set up to fetch the entire game object from the
  /// server as JSON which is parsed into the client-side [Game] counterpart
  /// object.
  // void loadRemoteConfig() async {
  //   // emit(RemoteConfigLoading());

  //   late Json? remoteConfig;
  //   try {
  //     remoteConfig = await endpointService.getGameData();
  //     game.applyJson(remoteConfig);
  //   } catch (e) {
  //     emit(RemoteConfigFailure());
  //   }

  // emit(RemoteConfigSuccess());
  // }

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
  void registerPlayer({required String displayName}) async {
    emit(JoinGameLoading());
    try {
      final playerId =
          await endpointService.registerPlayer(displayName: displayName);
      // Set the activte player to be what is returned from register_player.
      clientPlayerId = playerId;
      updateGameData();
      emit(JoinGameSuccess(game: game));
    } catch (e) {
      emit(JoinGameFailure(object: e));
    }
  }

  /// Roll dice during a player's active turn.
  ///
  /// The client should only be able to call this
  void rollDice() async {
    emit(GameActionLoading());
    try {
      await endpointService.rollDice(clientPlayerId!);
      updateGameData();
      emit(GameActionSuccess(game: game));
    } catch (e) {
      emit(GameActionFailure(object: e));
    }
  }

  /// End a player's turn.
  ///
  /// The client should only be able to call this
  void endTurn() async {
    emit(GameActionLoading());
    try {
      await endpointService.endTurn(clientPlayerId!);
      updateGameData();
      emit(GameActionSuccess(game: game));
    } catch (e) {
      emit(GameActionFailure(object: e));
    }
    // emit(ActiveTurnRollPhase());
  }

  void startGame() async {
    emit(GameActionLoading());
    try {
      await endpointService.startGame(playerId: clientPlayerId!);
      updateGameData();
      emit(GameActionSuccess(game: game));
      updateGameData();
    } catch (e) {
      emit(GameActionFailure(object: e));
    }
  }

  // Hardcoded to use admin ID for now
  void resetGame({bool useAdmin = false}) async {
    PlayerId playerId;
    if (useAdmin) {
      playerId = PlayerId('admin');
    } else {
      playerId = clientPlayerId!;
    }
    emit(GameActionLoading());
    try {
      await endpointService.reset(playerId: playerId);
      updateGameData(useAdmin: true);
      emit(GameActionSuccess(game: game));
    } catch (e) {
      emit(GameActionFailure(object: e));
    }
  }

  void buyProperty() async {
    emit(GameActionLoading());
    final int tileId = game.players[clientPlayerId]!.location!;
    try {
      await endpointService.buyProperty(clientPlayerId!, tileId);
      updateGameData();
      emit(GameActionSuccess(game: game));
    } catch (e) {
      emit(GameActionFailure(object: e));
    }
  }

  void setImprovements(int tileId, int quantity) async {
    emit(GameActionLoading());
    try {
      await endpointService.setImprovements(clientPlayerId!, tileId, quantity);
      updateGameData();
      emit(GameActionSuccess(game: game));
    } catch (e) {
      emit(GameActionFailure(object: e));
    }
  }

  void setMortgage(int tileId, bool mortgage) async {
    emit(GameActionLoading());
    try {
      await endpointService.setMortgage(clientPlayerId!, tileId, mortgage);
      updateGameData();
      emit(GameActionSuccess(game: game));
    } catch (e) {
      emit(GameActionFailure(object: e));
    }
  }

  void getOutOfJail(JailMethod jailMethod) async {
    emit(GameActionLoading());
    try {
      await endpointService.getOutOfJail(clientPlayerId!, jailMethod);
      updateGameData();
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
