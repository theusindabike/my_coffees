import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_coffees/feed/coffee/coffee.dart';

part 'coffee_state.dart';

class CoffeeCubit extends Cubit<CoffeeState> {
  CoffeeCubit(this._coffeeRepository) : super(CoffeeState());

  final CoffeeRepository _coffeeRepository;

  Future<void> getRandomCoffee() async {
    emit(state.copyWith(status: CoffeeStatus.loading));

    try {
      final coffeeRepositoryResult = await _coffeeRepository.getRandomCoffee();

      final coffeeUIResult = Coffee.fromRepository(coffeeRepositoryResult);

      emit(state.copyWith(
        status: CoffeeStatus.success,
        coffee: coffeeUIResult,
      ));
    } on Exception {
      emit(state.copyWith(status: CoffeeStatus.failure));
    }
  }
}
