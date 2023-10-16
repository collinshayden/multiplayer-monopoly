part of 'board_config_cubit.dart';

abstract class BoardConfigState {}

class BoardConfigInitial extends BoardConfigState {
  String? monetaryUnitSymbol;
  String? monetaryUnitName;
  Map<int, Color>? tierColors;

  BoardConfigInitial() {
    loadLocalConfig();
  }

  void loadLocalConfig() async {
    final json = await readJson('board_config.json');

    monetaryUnitName = json['monetaryUnit']['name'];
    monetaryUnitSymbol = json['monetaryUnit']['symbol'];
  }
}
