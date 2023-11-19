import 'package:flutter_test/flutter_test.dart';
import 'package:client/model/event.dart';

void main() {
  late Event sut; // "System under test"

  // Runs before each and every test.
  setUp(() {
    sut = Event.fromJson(<String, dynamic>{
      'type': 'showPlayerJoin',
      'firstParam': 1,
      'secondParam': 2,
      'thirdParam': 3,
      'fourthParam': 4,
    });
  });

  test('Enum loading works.', () {
    expect(sut.type, EventType.showPlayerJoin);
  });
}
