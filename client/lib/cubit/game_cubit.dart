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

  void updateGameData() async {
    emit(ActionRequesting());
    late Json? gameData;
    try {
      gameData = await endpointService.getGameData();
      game.withJson(gameData);
      print(gameData);
    } catch (e) {
      emit(ActionRejected());
    }
  }

  void updateGameData() async {
    emit(ActionRequesting());
    late Json? gameData;
    try {
      gameData = await endpointService.getGameData();
      game.withJson(gameData);
      print(gameData);
    } catch (e) {
      emit(ActionRejected());
    }
  }

  /// Load remote config from the server and emit the result.
  ///
  /// This function is currently set up to fetch the entire game object from the
  /// server as JSON which is parsed into the client-side [Game] counterpart
  /// object.
  void loadRemoteConfig() async {
    emit(RemoteConfigLoading());

    late Json? remoteConfig;
    try {
      remoteConfig = await endpointService.getGameData();
      game.withJson(remoteConfig);
    } catch (e) {
      emit(RemoteConfigFailure());
    }

    emit(RemoteConfigSuccess());
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
      endpointService.registerPlayer(displayName: displayName);
    } catch (e) {
      emit(JoinGameFailure());
    }
  }

  /// Roll dice during a player's active turn.
  ///
  /// The client should only be able to call this
  void rollDice({required String playerId}) async {
    emit(ActiveTurnRollPhase());
    try {
      endpointService.rollDice(playerId);
    } catch (e) {
      emit(GameErrorState());
    }
    emit(ActiveTurnRollPhase());
  }
}
