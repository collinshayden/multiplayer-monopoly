import 'dart:convert';
import 'package:flutter/services.dart';

Future<Map<String, dynamic>> readJson() async {
  final file = await rootBundle.loadString('assets/playerdata.json');
  final json = jsonDecode(file);
  return json;
}
