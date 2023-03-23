part of 'coffee_cubit.dart';

enum CoffeeStatus {
  initial,
  loading,
  success,
  failure;

  bool get isInitial => this == CoffeeStatus.initial;
  bool get isLoading => this == CoffeeStatus.loading;
  bool get isSuccess => this == CoffeeStatus.success;
  bool get isFailure => this == CoffeeStatus.failure;
}

class CoffeeState extends Equatable {
  const CoffeeState({
    this.status = CoffeeStatus.initial,
    Coffee? coffee,
  }) : coffee = coffee ?? Coffee.empty;

  final CoffeeStatus status;
  final Coffee coffee;

  CoffeeState copyWith({
    CoffeeStatus? status,
    Coffee? coffee,
  }) {
    return CoffeeState(
        status: status ?? this.status, coffee: coffee ?? this.coffee);
  }

  @override
  List<Object> get props => [status, coffee];
}
