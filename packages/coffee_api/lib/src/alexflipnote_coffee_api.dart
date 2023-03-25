import 'dart:convert';

import 'package:coffee_api/coffee_api.dart';
import 'package:http/http.dart' as http;

class CoffeeRequestFailure implements Exception {}

class CoffeNotFoundFailure implements Exception {}

/// {@template alexflipnote_coffee_api}
/// Dart API Client which wraps the [Open Meteo API](https://coffee.alexflipnote.dev/).
/// {@endtemplate}
class AlexflipnoteCoffeeAPI {
  /// {@macro alexflipnote_coffee_api}
  AlexflipnoteCoffeeAPI({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrlCoffee = 'coffee.alexflipnote.dev';

  final http.Client _httpClient;

  Future<Coffee> getRandomCoffee() async {
    final coffeeRequest = Uri.https(_baseUrlCoffee, '/random.json');

    final coffeResponse = await _httpClient.get(coffeeRequest);

    if (coffeResponse.statusCode != 200) {
      throw CoffeeRequestFailure();
    }

    final coffeJson = jsonDecode(coffeResponse.body) as Map<String, dynamic>;

    if (coffeJson.isEmpty) throw CoffeNotFoundFailure();

    return Coffee.fromJson(coffeJson);
  }
}
