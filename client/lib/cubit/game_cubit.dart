import 'dart:convert';
import 'package:client/cubit/file_service.dart';
import 'package:client/cubit/endpoint_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'game_state.dart';

typedef Json = Map<String, dynamic>;

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameInitial());

  final fileService = FileService();
  final endpointService = EndpointService();
  late final Json localBoardConfig;

  void loadLocalConfig() async {
    emit(LocalConfigLoading());
    try {
      localBoardConfig =
          jsonDecode(await fileService.readFile('board_config.json'));
    } catch (e) {
      emit(LocalConfigFailure(e));
    } finally {}
    await Future.delayed(Duration(seconds: 3)); // TODO: Remove
    emit(LocalConfigSuccess(boardJson: localBoardConfig));
  }

  void loadRemoteConfig() async {}
}
