import 'package:client/json_utils.dart';
import 'package:client/view/dice.dart';
import 'package:flutter/material.dart';

class Roll {
  Roll({
    this.first,
    this.second,
  });

  int? first;
  int? second;

  void applyJson(Json? json) {
    if (json == null) return;
    first = json['first'] ?? first;
    second = json['second'] ?? second;
  }

  bool _ensureCompleteRoll() {
    return (first != null && second != null);
  }

  Widget createWidget() {
    return const Dice(
      first: 1,
      second: 2,
    );
  }
}
