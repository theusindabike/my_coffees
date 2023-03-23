import 'package:coffee_api/coffee_api.dart';

class CoffeeRepository {
  CoffeeRepository({AlexflipnoteCoffeeAPI? alexflipnoteCoffeeAPI})
      : _coffeeAPI = alexflipnoteCoffeeAPI ?? AlexflipnoteCoffeeAPI();

  final AlexflipnoteCoffeeAPI _coffeeAPI;

  Future<Coffee> getRandomCoffee() {
    return _coffeeAPI.getRandomCoffee();
  }
}
