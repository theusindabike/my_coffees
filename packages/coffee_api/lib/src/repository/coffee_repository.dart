import 'package:coffee_api/coffee_api.dart';

class CoffeeRepository {
  CoffeeRepository({AlexflipnoteCoffeeAPI? coffeeAPI})
      : _coffeeAPI = coffeeAPI ?? AlexflipnoteCoffeeAPI();

  final AlexflipnoteCoffeeAPI _coffeeAPI;

  Future<Coffee> getRandomCoffee() async {
    return _coffeeAPI.getRandomCoffee();
  }
}
