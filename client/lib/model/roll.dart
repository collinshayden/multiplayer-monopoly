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

  void withJson(Json? json) {
    if (json == null) return;
    first = json['first'] ?? first;
    second = json['second'] ?? second;
  }

  bool _ensureCompleteRoll() {
    return (first != null && second != null);
  }

  Widget createWidget() {
    assert(_ensureCompleteRoll(), "Roll value(s) are null");

    return Container(
      child: Dice(value1: 1, value2: 2,),
    );
  }
}
