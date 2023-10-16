/// Reading json data into dart data types
/// Author: Hayden Collins
/// Date: 10/12/2023

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

// temp function, TODO read from .json file (was having trouble)
readJson(String data) {
  return jsonDecode(data);
}

class PlayerData {
  PlayerData({required this.money, required this.location, required this.properties, required this.jail_card});
  int money;
  int location;
  Map<String, dynamic> properties;
  bool jail_card;

  factory PlayerData.fromJson(Map<String, dynamic> data) {
    int money = data['money'] as int;
    int location = data['money'] as int;
    Map<String, dynamic> properties = data['properties'];
    bool? jail_card = data['jail_card'] as bool?;
    return PlayerData(money: money, location: location, properties: properties, jail_card: jail_card ?? false);
  }

  void setMoney(int val) {
    money = val;
  }

  void setLocation(int val) {
    location = val;
  }

  // void setProperties(Map props) {
  //   properties = props;
  // }

  void setJailCard(bool val) {
    jail_card = val;
  }
}



