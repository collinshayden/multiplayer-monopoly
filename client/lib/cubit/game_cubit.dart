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

  void loadLocalConfig() async {
    // Loaing local config
    emit(LocalConfigLoading());
    await Future.delayed(Duration(seconds: 1)); // TODO: Remove
    late Json? localTileConfig;
    try {
      localTileConfig = await fileService.getLocalTileConfig();
      game.withJson(localTileConfig);
      print(localTileConfig);
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
