/// Reading json data into dart data types
/// Author: Hayden Collins
/// Date: 10/12/2023

import 'dart:convert';
import 'dart:io';
import 'package:client/model/game_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';


// function to read json data
Future<Map<String, dynamic>> readJson() async {
  final file = await rootBundle.loadString('assets/playerdata.json');
  final json = jsonDecode(file);
  return json;
}

// endpoint class 
// read a .dart file with json information into a map
// 



