import 'dart:convert';
import 'package:flutter/services.dart';
import '../constants.dart';

/// Retrieves files from the root bundle created by the framework for the
/// application.
class FileService {
  /// Internal constructor which should only be called once by the class itself.
  FileService._internal();

  /// Factory constructor which returns the singleton.
  factory FileService() => _instance;

  // Instantiate singleton
  static final FileService _instance = FileService._internal();

  /// Reads json in from a path within the assets folder.
  Future<Map<String, dynamic>> readJson(String assetPath) async {
    final file = await readFile(assetPath);
    final json = jsonDecode(file);
    return json;
  }

  /// Reads a file in as a string.
  Future<String> readFile(String assetPath) async {
    final file = await rootBundle.loadString('$LOCAL_ASSET_DIR$assetPath');
    return file;
  }
}
