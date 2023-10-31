import 'package:client/cubit/file_service.dart';
import 'package:client/cubit/endpoint_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameInitial());

  final fileService = FileService();
  final endpointService = EndpointService();

  void loadLocalConfig() async {
    emit(LocalConfigLoading());
    final boardConfig = await fileService.readFile('board_config.json');
    await Future.delayed(Duration(seconds: 3));
    print(boardConfig);
    emit(LocalConfigSuccess());
  }
}
