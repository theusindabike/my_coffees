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

@JsonSerializable(explicitToJson: true)
class CoffeeState extends Equatable {
  CoffeeState({
    this.status = CoffeeStatus.initial,
    Coffee? feedCoffee,
    Set<Coffee>? favoritesCoffees,
  })  : feedCoffee = feedCoffee ?? Coffee.empty,
        favoritesCoffees = favoritesCoffees ?? <Coffee>{};

  final CoffeeStatus status;
  final Coffee feedCoffee;
  late final Set<Coffee> favoritesCoffees;

  factory CoffeeState.fromJson(Map<String, dynamic> json) =>
      _$CoffeeStateFromJson(json);

  Map<String, dynamic> toJson() => _$CoffeeStateToJson(this);

  @override
  List<Object> get props => [status, feedCoffee, favoritesCoffees];

  void addFeedCoffeToFavotite() {
    favoritesCoffees.add(feedCoffee);
  }

  void cleanFavoritesCoffees() {
    favoritesCoffees = <Coffee>{};
  }

  CoffeeState copyWith({
    CoffeeStatus? status,
    Coffee? feedCoffee,
    Set<Coffee>? favoritesCoffees,
  }) {
    return CoffeeState(
      status: status ?? this.status,
      feedCoffee: feedCoffee ?? this.feedCoffee,
      favoritesCoffees: favoritesCoffees ?? this.favoritesCoffees,
    );
  }
}
