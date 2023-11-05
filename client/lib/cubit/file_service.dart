import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:client/constants.dart';
import 'package:client/json_utils.dart';

/// Retrieves files from the root bundle created by the framework for the
/// application.
class FileService {
  /// Internal constructor which should only be called once by the class itself.
  FileService._internal();

  /// Factory constructor which returns the singleton.
  factory FileService() => _instance;

  // Instantiate singleton
  static final FileService _instance = FileService._internal();

  /// Reads in board config from local files as JSON.
  Future<Json> getLocalTileConfig() async {
    String serializedTileConfig =
        await rootBundle.loadString('$LOCAL_ASSET_DIR/local_config.json');
    Json localTileConfig = jsonDecode(serializedTileConfig);
    return localTileConfig;
  }
}
