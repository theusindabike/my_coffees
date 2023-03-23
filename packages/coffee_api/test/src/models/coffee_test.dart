import 'package:coffee_api/coffee_api.dart';
import 'package:test/test.dart';

void main() {
  group('Coffee', () {
    group('fromJson', () {
      test('returns correct Coffee object', () {
        expect(
          Coffee.fromJson(
            <String, dynamic>{
              'file': 'https://coffee.alexflipnote.dev/Y6itKvnyMps_coffee.jpg',
            },
          ),
          isA<Coffee>().having((w) => w.imageUrl, 'imageUrl',
              'https://coffee.alexflipnote.dev/Y6itKvnyMps_coffee.jpg'),
        );
      });
    });
  });
}
