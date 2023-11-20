import 'package:client/cubit/endpoint_service.dart';
import 'package:client/cubit/file_service.dart';
import 'package:client/cubit/game_cubit.dart';
import 'package:client/model/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGame extends Mock implements Game {}

class MockFileService extends Mock implements FileService {}

class MockEndpointService extends Mock implements EndpointService {}

void main() {
  late GameCubit sut; // "System under test"

  // Mock services
  late MockGame mockGame;
  late MockFileService mockFileService;
  late MockEndpointService mockEndpointService;

  // Runs before each and every test.
  setUp(() {
    mockGame = MockGame();
    mockFileService = MockFileService();
    mockEndpointService = MockEndpointService();
    sut = GameCubit(
      game: mockGame,
      fileService: mockFileService,
      endpointService: mockEndpointService,
    );
  });

  test("Initial values are correct", () {
    expect(sut.state.runtimeType, GameInitial);
    expect(sut.clientPlayerId, null);
  });
}
