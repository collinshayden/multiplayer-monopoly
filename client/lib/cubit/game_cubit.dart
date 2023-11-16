import 'package:client/constants.dart';
import 'package:client/model/player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/model/game.dart';
import 'package:client/cubit/file_service.dart';
import 'package:client/cubit/endpoint_service.dart';
import 'package:client/json_utils.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameInitial());

  // Initialise game
  final game = Game();
  // Player ID used to authenticate requests.
  // Gathered from register_player()
  PlayerId clientPlayerId = PlayerId("");

  // Initialise services
  final fileService = FileService();
  final endpointService = EndpointService();

  /// Load local configuration files and emit the result.
  ///
  /// This function loads local configuration from persistent memory stored as
  /// JSON. A [LocalConfigLoading] state is always emitted, and then either a
  /// [LocalConfigFailure] or [LocalConfigSuccess] will emitted dependent on
  /// whether the config was able to be loaded by the file service and
  /// deserialised into a [Game] object.
  void loadLocalConfig() async {
    emit(LocalConfigLoading());
    await Future.delayed(const Duration(seconds: 1)); // TODO: Remove

    late Json? localConfig;
    try {
      localConfig = await fileService.getLocalConfig();
      game.withJson(localConfig);
    } catch (e) {
      emit(LocalConfigFailure(e));
    }
    emit(LocalConfigSuccess(game: game));
  }

  // Hardcoded to use admin ID for now
  void updateGameData({bool useAdmin = false}) async {
    emit(GameStateUpdateLoading());
    late Json? gameData;
    var playerId = clientPlayerId;
    if (useAdmin) {
      playerId = PlayerId('admin');
    }
    try {
      gameData = await endpointService.getGameData(playerId: playerId);
      game.withJson(gameData);
      emit(GameStateUpdateSuccess());
      // print(gameData);
    } catch (e) {
      emit(GameStateUpdateFailure());
      // emit(ActionRejected());
    }
  }

  /// Load remote config from the server and emit the result.
  ///
  /// This function is currently set up to fetch the entire game object from the
  /// server as JSON which is parsed into the client-side [Game] counterpart
  /// object.
  void loadRemoteConfig() async {
    // emit(RemoteConfigLoading());

    // late Json? remoteConfig;
    // try {
    //   remoteConfig = await endpointService.getGameData();
    //   game.withJson(remoteConfig);
    // } catch (e) {
    //   emit(RemoteConfigFailure());
    // }

    // emit(RemoteConfigSuccess());
  }

  /// Method to get the location of the active player.
  int? getActivePlayerLocation() {
    return game.getPlayerLocation(clientPlayerId);
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
      clientPlayerId = PlayerId(playerId);
      updateGameData();
    } catch (e) {
      emit(JoinGameFailure());
    }
  }

  /// Roll dice during a player's active turn.
  ///
  /// The client should only be able to call this
  void rollDice() async {
    emit(GameActionLoading());
    try {
      endpointService.rollDice(clientPlayerId);
      updateGameData();
      emit(GameActionSuccess());
    } catch (e) {
      emit(GameErrorState());
    }
  }

  /// End a player's turn.
  ///
  /// The client should only be able to call this
  void endTurn() async {
    emit(GameActionLoading());
    try {
      endpointService.endTurn(clientPlayerId);
      updateGameData();
      emit(GameActionSuccess());
    } catch (e) {
      emit(GameActionFailure());
    }
  }

  void startGame() async {
    emit(GameActionLoading());
    try {
      endpointService.startGame(playerId: clientPlayerId);
      updateGameData();
      emit(GameActionSuccess());
    } catch (e) {
      emit(GameActionFailure());
    }
  }

  // Hardcoded to use admin ID for now
  void resetGame({bool useAdmin = false}) async {
    var playerId = clientPlayerId;
    emit(GameActionLoading());
    if (useAdmin) {
      playerId = PlayerId('admin');
    }
    try {
      endpointService.reset(playerId: playerId);
      updateGameData(useAdmin: true);
      emit(GameActionSuccess());
    } catch (e) {
      emit(GameActionFailure());
    }
  }

  void buyProperty(int tileId) async {
    emit(GameActionLoading());
    try {
      endpointService.buyProperty(clientPlayerId, tileId);
      updateGameData();
      emit(GameActionSuccess());
    } catch (e) {
      emit(GameActionFailure());
    }
  }

  void setImprovements(int tileId, int quantity) async {
    emit(GameActionLoading());
    try {
      endpointService.setImprovements(clientPlayerId, tileId, quantity);
      updateGameData();
      emit(GameActionSuccess());
    } catch (e) {
      emit(GameActionFailure());
    }
  }

  void setMortgage(int tileId, bool mortgage) async {
    emit(GameActionLoading());
    try {
      endpointService.setMortgage(clientPlayerId, tileId, mortgage);
      updateGameData();
      emit(GameActionSuccess());
    } catch (e) {
      emit(GameActionFailure());
    }
  }

  void getOutOfJail(JailMethod jailMethod) async {
    emit(GameActionLoading());
    try {
      endpointService.getOutOfJail(clientPlayerId, jailMethod);
      updateGameData();
      emit(GameActionSuccess());
    } catch (e) {
      emit(GameActionFailure());
    }
  }

  /// Method used in the admin buttons to change the clientPlayerId to the
  /// Game object's active player ID. Allows you to simulate multiple users.
  void switchActivePlayerId() {
    try {
      final originalId = clientPlayerId.value;
      clientPlayerId = game.activePlayerId!;
      print("ID was ${originalId} and is now ${clientPlayerId.value}");
    } catch (e) {}
  }
}
