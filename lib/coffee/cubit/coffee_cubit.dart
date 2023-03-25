import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_coffees/coffee/coffee.dart';

part 'coffee_cubit.g.dart';
part 'coffee_state.dart';

class CoffeeCubit extends HydratedCubit<CoffeeState> {
  CoffeeCubit(this._coffeeRepository) : super(CoffeeState());

  final CoffeeRepository _coffeeRepository;

  Future<void> getRandomCoffee() async {
    emit(state.copyWith(status: CoffeeStatus.loading));

    try {
      final coffeeRepositoryResult = await _coffeeRepository.getRandomCoffee();

      final feedCoffeeResult = Coffee.fromRepository(coffeeRepositoryResult);

      emit(
        state.copyWith(
          status: CoffeeStatus.success,
          feedCoffee: feedCoffeeResult,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: CoffeeStatus.failure));
    }
  }

  void addFavoriteCoffee() {
    final updatedFavoritesCoffees = Set<Coffee>.from(state.favoritesCoffees)
      ..add(state.feedCoffee);
    emit(state.copyWith(favoritesCoffees: updatedFavoritesCoffees));
  }

  @override
  CoffeeState fromJson(Map<String, dynamic> json) => CoffeeState.fromJson(json);

  @override
  Map<String, dynamic> toJson(CoffeeState state) => state.toJson();
}
