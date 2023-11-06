import 'package:client/json_utils.dart';

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
}
