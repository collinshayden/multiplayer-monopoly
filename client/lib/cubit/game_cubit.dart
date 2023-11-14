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
    // Loading local config
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

  void joinGame({required String displayName}) async {
    emit(JoinGameLoading());
    try {
      endpointService.registerPlayer(displayName: displayName);
    } catch (e) {
      emit(JoinGameFailure());
    }
  }

  void rollDice({required String playerId}) async {
    emit(ActionRequesting());
    try {
      endpointService.rollDice(playerId);
    } catch (e) {
      emit(ActionRejected());
    }
  }

  void loadRemoteConfig() async {
    // Loaing local config
    emit(RemoteConfigLoading());
    late Json? remoteConfig;
    try {
      remoteConfig = await endpointService.getGameData();
      game.withJson(remoteConfig);
      print(remoteConfig);
    } catch (e) {
      emit(RemoteConfigFailure());
    }

    emit(RemoteConfigSuccess());
  }
}
