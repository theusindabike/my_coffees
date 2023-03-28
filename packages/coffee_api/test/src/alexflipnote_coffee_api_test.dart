import 'package:coffee_api/coffee_api.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('AlexflipnoteCoffeeAPI', () {
    late http.Client httpClient;
    late AlexflipnoteCoffeeAPI api;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      api = AlexflipnoteCoffeeAPI(httpClient: httpClient);
    });

    group('constructor', () {
      test('does not require an httpClient', () {
        expect(AlexflipnoteCoffeeAPI(), isNotNull);
      });
    });

    group('randomCoffee', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        try {
          await api.getRandomCoffee();
        } catch (_) {}
        verify(
          () => httpClient.get(
            Uri.https(
              'coffee.alexflipnote.dev',
              '/random.json',
            ),
          ),
        ).called(1);
      });

      test('throws CoffeeRequestFailure on non-200 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          () async => api.getRandomCoffee(),
          throwsA(isA<CoffeeRequestFailure>()),
        );
      });

      test('throws CoffeNotFoundFailure on empty body response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        await expectLater(
          api.getRandomCoffee(),
          throwsA(isA<CoffeNotFoundFailure>()),
        );
      });

      test('returns Coffee on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '{"file": "https://coffee.alexflipnote.dev/Y6itKvnyMps_coffee.jpg"}',
        );
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        final actual = await api.getRandomCoffee();
        expect(
          actual,
          isA<Coffee>().having(
            (c) => c.imageUrl,
            'imageUrl',
            'https://coffee.alexflipnote.dev/Y6itKvnyMps_coffee.jpg',
          ),
        );
      });
    });
  });
}
