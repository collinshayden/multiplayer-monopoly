import 'package:client/cubit/file_service.dart';
import 'package:client/cubit/endpoint_service.dart';
import 'package:client/model/tile_data.dart';
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
    await Future.delayed(Duration(seconds: 1)); // TODO: Remove

    try {
      localBoardConfig = await fileService.loadLocalBoardConfig();
    } catch (e) {
      emit(LocalConfigFailure(e));
    }

    emit(LocalConfigSuccess(boardJson: parseLocalConfig(localBoardConfig)));
  }

  void joinGame({required String displayName}) async {
    emit(JoinGameLoading());
    try {
      endpointService.registerPlayer(displayName: displayName);
    } catch (e) {
      emit(JoinGameFailure());
    }
  }

  void loadRemoteConfig() async {}
}

Map<String, dynamic> parseLocalConfig(Map<String, dynamic> json) {
  Map<int, TileData> tileData = {};
  String monetaryUnitName = json["monetaryUnitName"];
  String monetaryUnitSymbol = json["monetaryUnitSymbol"];
  List<String> propertyColorsARGB = json["propertyColorsARGB"];
  for (int i = 0; i < json["tiles"].size(); i++) {
    Map<String, dynamic> tile = json["tiles"]["${i + 1}"];
    switch (tile["type"]) {
      case "corner":
        tileData[i] = CornerTileData(
            id: tile["id"],
            quarterTurns: tile["quarterTurns"],
            upperText: tile["upperText"],
            imagePath: tile["imagePath1"]);
      case "improvement":
        tileData[i] = ImprovableTileData(
            id: tile["id"],
            quarterTurns: tile["quarterTurns"],
            owner: tile["owner"],
            improvements: tile["improvements"],
            color: tile["color"],
            price: tile["price"],
            title: tile["title"]);
      case "chance":
        tileData[i] = ChanceTileData(
            id: tile["id"],
            quarterTurns: tile["quarterTurns"],
            title: tile["title"],
            imagePath: tile["imagePath"]);
      case "community":
        tileData[i] = CommunityTileData(
            id: tile["id"],
            quarterTurns: tile["quarterTurns"],
            title: tile["title"],
            imagePath: tile["imagePath"]);
      case "railroad":
        tileData[i] = RailroadTileData(
            id: tile["id"],
            quarterTurns: tile["quarterTurns"],
            title: tile["title"],
            imagePath: tile["imagePath"],
            price: tile["price"]);
      case "utility":
        tileData[i] = UtilityTileData(
            id: tile["id"],
            quarterTurns: tile["quarterTurns"],
            title: tile["title"],
            imagePath: tile["imagePath"],
            price: tile["price"]);
      case "tax":
        tileData[i] = TaxTileData(
            id: tile["id"],
            quarterTurns: tile["quarterTurns"],
            title: tile["title"],
            imagePath: tile["imagePath"],
            payCommandText: tile["payCommandText"]);
    }
  }

  Map<String, dynamic> rtnval = {
    "tileData": tileData,
    "propertyColorsARGB": propertyColorsARGB
  };
  return rtnval;
}
