import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'dart:convert';

Future<String> loadFile(String path) {
  return rootBundle.loadString(path);
}

Future<Map<String, dynamic>> readJson(String path) async {
  final string = await loadFile(path);
  return await jsonDecode(string);
}
