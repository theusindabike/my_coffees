// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coffee_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoffeeState _$CoffeeStateFromJson(Map<String, dynamic> json) => $checkedCreate(
      'CoffeeState',
      json,
      ($checkedConvert) {
        final val = CoffeeState(
          status: $checkedConvert(
              'status',
              (v) =>
                  $enumDecodeNullable(_$CoffeeStatusEnumMap, v) ??
                  CoffeeStatus.initial),
          feedCoffee: $checkedConvert(
              'feed_coffee',
              (v) => v == null
                  ? null
                  : Coffee.fromJson(v as Map<String, dynamic>)),
          favoritesCoffees: $checkedConvert(
              'favorites_coffees',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => Coffee.fromJson(e as Map<String, dynamic>))
                  .toSet()),
        );
        return val;
      },
      fieldKeyMap: const {
        'feedCoffee': 'feed_coffee',
        'favoritesCoffees': 'favorites_coffees'
      },
    );

Map<String, dynamic> _$CoffeeStateToJson(CoffeeState instance) =>
    <String, dynamic>{
      'status': _$CoffeeStatusEnumMap[instance.status]!,
      'feed_coffee': instance.feedCoffee.toJson(),
      'favorites_coffees':
          instance.favoritesCoffees.map((e) => e.toJson()).toList(),
    };

const _$CoffeeStatusEnumMap = {
  CoffeeStatus.initial: 'initial',
  CoffeeStatus.loading: 'loading',
  CoffeeStatus.success: 'success',
  CoffeeStatus.failure: 'failure',
};
