import 'package:client/json_utils.dart';

class RollData {
  int get first => _first;
  int _first;
  set first(int value) {
    assert(1 <= value && value <= 6);
    if (value == first) return;
    _first = value;
  }

  int get second => _second;
  int _second;
  set second(int value) {
    assert(1 <= value && value <= 6);
    if (value == second) return;
    _second = value;
  }

  int get sum => first + second;
  bool get isDoubles => first == second;

  update();
  updatejsonBindings(Json json) {
    first = json['first'] ?? first;
    second = json['second'] ?? second;
  }
}
