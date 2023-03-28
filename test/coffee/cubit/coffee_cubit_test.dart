import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_api/coffee_api.dart' as coffee_api;
import 'package:mocktail/mocktail.dart';
import 'package:my_coffees/coffee/coffee.dart';
import 'package:test/test.dart';

import '../../helpers/helpers.dart';

const coffeeImageUrl = 'https://coffee.alexflipnote.dev/Y6itKvnyMps_coffee.jpg';

class MockCoffeeRepository extends Mock
    implements coffee_api.CoffeeRepository {}

class MockCoffee extends Mock implements coffee_api.Coffee {}

void main() {
  initHydratedStorage();
  group('Coffee Cubit', () {
    late coffee_api.Coffee coffee;
    late coffee_api.CoffeeRepository coffeeRepository;
    late CoffeeCubit coffeeCubit;

    setUp(() async {
      coffee = MockCoffee();
      coffeeRepository = MockCoffeeRepository();
      coffeeCubit = CoffeeCubit(coffeeRepository);

      when(() => coffee.imageUrl).thenReturn(coffeeImageUrl);
      when(
        () => coffeeRepository.getRandomCoffee(),
      ).thenAnswer((_) async => coffee);
    });
    group('constructor', () {
      test('instantiates coffee cubit correctly', () {
        final coffeeCubit = CoffeeCubit(coffeeRepository);
        expect(coffeeCubit.state, CoffeeState());
      });
    });

    group('getRandomCoffee', () {
      blocTest<CoffeeCubit, CoffeeState>(
        'calls coffe_api repository',
        build: () => coffeeCubit,
        act: (cubit) => cubit.getRandomCoffee(),
        verify: (_) {
          verify(
            () => coffeeRepository.getRandomCoffee(),
          ).called(1);
        },
      );
    });

    group('addFavoriteCoffee', () {
      blocTest<CoffeeCubit, CoffeeState>(
        'calls addFavoriteCoffee',
        build: () => coffeeCubit,
        act: (cubit) => cubit.addFavoriteCoffee(),
        expect: () => <dynamic>[
          isA<CoffeeState>().having(
            (cs) => cs.favoritesCoffees,
            'favoritesCoffees',
            isA<Set<Coffee>>(),
          ),
        ],
      );
    });

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [loading, failure] when getRandomCoffee throws',
      setUp: () {
        when(
          () => coffeeRepository.getRandomCoffee(),
        ).thenThrow(Exception('failed'));
      },
      build: () => coffeeCubit,
      act: (cubit) => cubit.getRandomCoffee(),
      expect: () => <CoffeeState>[
        CoffeeState(status: CoffeeStatus.loading),
        CoffeeState(status: CoffeeStatus.failure),
      ],
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [loading, success] when getRandomCoffee returns an imageUrl',
      build: () => coffeeCubit,
      act: (cubit) => cubit.getRandomCoffee(),
      expect: () => <dynamic>[
        CoffeeState(
          status: CoffeeStatus.loading,
        ),
        isA<CoffeeState>()
            .having((cs) => cs.status, 'status', CoffeeStatus.success)
            .having(
              (cs) => cs.feedCoffee,
              'coffee',
              isA<Coffee>()
                  .having((c) => c.imageUrl, 'imageUrl', coffeeImageUrl),
            ),
      ],
    );
  });
}
