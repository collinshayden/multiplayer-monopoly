import 'dart:convert';
import 'constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;

/// Convenience typedef for JSON representations.
typedef Json = Map<String, dynamic>;

/// Asynchronously load a JSON file from local assets.
///
/// This function depends on `LOCAL_ASSET_DIR` being properly set to the assets
/// directory of the application (without a trailing '/'). The `path` paramter
/// must end with '.json' to be valid.
Future<Json> loadJsonFromLocalAssets(String path) async {
  String rawString = '';
  try {
    rawString = await rootBundle.loadString('$LOCAL_ASSET_DIR/$path');
  } catch (e) {
    debugPrint(
        'An error occurred while loading a local asset: $LOCAL_ASSET_DIR/$path');
  }
  Json json = jsonDecode(rawString);
  return json;
}
