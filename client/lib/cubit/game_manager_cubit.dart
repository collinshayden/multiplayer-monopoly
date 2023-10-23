import 'package:client/model/endpoint_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/game_state.dart';

class GameManagerCubit extends Cubit<GameState> {
  EndpointManager endpoint = EndpointManager();
  GameManagerCubit() : super(GameState.initial());

  void rollDice() {
    return;
  }
}
