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

    monetaryUnitName = json['monetaryUnit']['name'] as String;
    monetaryUnitSymbol = json['monetaryUnit']['symbol'] as String;

    // TODO: add other fields
  }
}

class AppConfiguration {
  // Named constructor for the static internal instance
  AppConfiguration._internal();

  static final _globConfig = "globConfig";

  static final _singleton = AppConfiguration._internal();

  factory AppConfiguration() {
    return _singleton;
  }

  final _configs = Map<String, dynamic>();

  Future<AppConfiguration> loadConfigs(String name, {String? category}) async {
    final configJsonString =
        await rootBundle.loadString("assets/configs/$name");

    Map<String, dynamic> configJson = jsonDecode(configJsonString);

    if (category == null || category.isEmpty) category = _globConfig;

    if (_configs[category] == null) _configs[category] = Map<String, dynamic>();

    _configs[category].addAll(configJson);

    return _singleton;
  }

  T getConfig<T>(String key, {String? category}) {
    if (category == null || category.isEmpty) category = _globConfig;
    return _configs[category][key] as T;
  }
}
