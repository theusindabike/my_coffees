import 'package:coffee_api/coffee_api.dart' as coffee_api;
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coffee.g.dart';

@JsonSerializable(explicitToJson: true)
class Coffee extends Equatable {
  const Coffee({
    required this.imageUrl,
  });

  factory Coffee.fromJson(Map<String, dynamic> json) => _$CoffeeFromJson(json);

  Map<String, dynamic> toJson() => _$CoffeeToJson(this);

  factory Coffee.fromRepository(coffee_api.Coffee coffeeFromRepository) {
    return Coffee(imageUrl: coffeeFromRepository.imageUrl);
  }

  //TODO: Should I use Uri type?
  final String imageUrl;

  static const empty = Coffee(imageUrl: '--');

  @override
  List<Object?> get props => [imageUrl];
}
