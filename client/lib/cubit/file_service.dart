import 'dart:convert';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../json_utils.dart';

/// Retrieves files from the root bundle created by the framework for the
/// application.
class FileService {
  /// Internal constructor which should only be called once by the class itself.
  FileService._internal();

  /// Factory constructor which returns the singleton.
  factory FileService() => _instance;

  // Instantiate singleton
  static final FileService _instance = FileService._internal();

  /// Reads JSON in from a path within the assets folder.
  Future<Json> loadLocalBoardConfig() async {
    Future<Json> localBoardConfig =
        loadJson('$LOCAL_ASSET_DIR/board_config.json');
    return localBoardConfig;
  }
}
