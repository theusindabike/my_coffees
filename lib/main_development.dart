import 'package:coffee_api/coffee_api.dart';
import 'package:my_coffees/app/app.dart';
import 'package:my_coffees/bootstrap.dart';
import 'package:my_coffees/feed/coffee/coffee.dart';

void main() {
  bootstrap(
    () => CoffeeApp(
      coffeeRepository: CoffeeRepository(),
    ),
  );
}
