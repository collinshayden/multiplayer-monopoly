import 'package:client/json_utils.dart';

class Roll {
  Roll({
    this.first,
    this.second,
  });

  int? first;
  int? second;

  void withJson(Json json) {
    first = json['first'] ?? first;
    second = json['second'] ?? second;
  }
}
