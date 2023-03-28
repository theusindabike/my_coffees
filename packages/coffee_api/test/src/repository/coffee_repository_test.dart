import 'package:coffee_api/coffee_api.dart' as coffee_api;
import 'package:coffee_api/src/repository/coffee_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCoffeeAPI extends Mock implements coffee_api.AlexflipnoteCoffeeAPI {}

void main() {
  group('Coffee Repository', () {
    late coffee_api.AlexflipnoteCoffeeAPI coffeeAPI;
    late CoffeeRepository coffeeRepository;

    setUp(() {
      coffeeAPI = MockCoffeeAPI();
      coffeeRepository = CoffeeRepository(coffeeAPI: coffeeAPI);
    });

    group('constructor', () {
      test('instantiates internal coffee api client when not injected', () {
        expect(CoffeeRepository(), isNotNull);
      });
    });

    group('getRandomCoffee', () {
      test('calls getRandomCoffee with success', () async {
        try {
          await coffeeRepository.getRandomCoffee();
        } catch (_) {}

        verify(() => coffeeAPI.getRandomCoffee()).called(1);
      });

      test('throws error when coffeeAPI fails', () async {
        final exception = Exception('fails');
        when(() => coffeeAPI.getRandomCoffee()).thenThrow(exception);

        expect(
          () async => coffeeRepository.getRandomCoffee(),
          throwsA(exception),
        );
      });
    });
  });
}
