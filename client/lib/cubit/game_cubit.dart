import 'package:client/cubit/file_service.dart';
import 'package:client/cubit/endpoint_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameInitial());

  final fileService = FileService();
  final endpointService = EndpointService();

  void loadLocalConfig() {
    emit(LocalConfigLoading());
    final boardConfig = fileService.readFile('board_config.json');
    print(boardConfig);
    emit(LocalConfigSuccess());
  }
}
