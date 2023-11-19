import 'package:client/json_utils.dart';
import 'package:client/view/game_screen/dice.dart';
import 'package:flutter/material.dart';

class Roll {
  Roll({
    this.first,
    this.second,
  });

  int? first;
  int? second;

  /// Determines whether this all values necessary for display are non-null.
  bool get _canCreateWidget => first != null && second != null;

  void applyJson(Json? json) {
    if (json == null) return;
    first = json['first'] ?? first;
    second = json['second'] ?? second;
  }

  Widget createWidget() {
    assert(_canCreateWidget);
    return const Dice(
      first: 1,
      second: 2,
    );
  }
}
