import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_api/coffee_api.dart' as coffee_api;
import 'package:coffee_api/coffee_api.dart' hide Coffee;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_coffees/coffee/coffee.dart';

import '../../helpers/helpers.dart';

class MockCoffeeRepository extends Mock
    implements coffee_api.CoffeeRepository {}

class MockCoffee extends Mock implements coffee_api.Coffee {}

class MockCoffeeCubit extends MockCubit<CoffeeState> implements CoffeeCubit {}

const coffeeImageUrl = 'https://coffee.alexflipnote.dev/Y6itKvnyMps_coffee.jpg';

void main() {
  initHydratedStorage();

  group('Coffee Page', () {
    late coffee_api.CoffeeRepository coffeeRepository;
    late CoffeeCubit coffeeCubit;

    setUp(() async {
      coffeeRepository = MockCoffeeRepository();
      coffeeCubit = MockCoffeeCubit();
      when(() => coffeeCubit.getRandomCoffee()).thenAnswer((_) async {});
      when(() => coffeeRepository.getRandomCoffee()).thenAnswer((_) async {
        return const coffee_api.Coffee(imageUrl: coffeeImageUrl);
      });
    });

    testWidgets('renders CoffeeView', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: coffeeRepository,
          child: const MaterialApp(home: CoffeePage()),
        ),
      );
      expect(find.byType(CoffeeView), findsOneWidget);
    });
  });
  group('CoffeeView', () {
    late coffee_api.CoffeeRepository coffeeRepository;
    late CoffeeCubit coffeeCubit;
    const coffee = Coffee(
      imageUrl: coffeeImageUrl,
    );

    setUp(() {
      coffeeRepository = MockCoffeeRepository();
      coffeeCubit = MockCoffeeCubit();
      when(() => coffeeCubit.getRandomCoffee()).thenAnswer((_) async {});
      when(() => coffeeRepository.getRandomCoffee()).thenAnswer((_) async {
        return const coffee_api.Coffee(imageUrl: coffeeImageUrl);
      });
    });

    testWidgets('renders CoffeeInitial for CoffeeStatus.initial',
        (tester) async {
      when(() => coffeeCubit.state).thenReturn(CoffeeState());
      await tester.pumpWidget(
        BlocProvider.value(
          value: coffeeCubit,
          child: const MaterialApp(home: CoffeeView()),
        ),
      );

      expect(find.byType(CoffeeEmpty), findsOneWidget);
    });

    testWidgets('renders CoffeeLoading for CoffeeStatus.loading',
        (tester) async {
      when(() => coffeeCubit.state)
          .thenReturn(CoffeeState(status: CoffeeStatus.loading));
      await tester.pumpWidget(
        BlocProvider.value(
          value: coffeeCubit,
          child: const MaterialApp(home: CoffeeView()),
        ),
      );

      expect(find.byType(CoffeeLoading), findsOneWidget);
    });

    testWidgets('renders CoffeePopulated for CoffeeStatus.success',
        (tester) async {
      when(() => coffeeCubit.state)
          .thenReturn(CoffeeState(status: CoffeeStatus.success));
      await tester.pumpWidget(
        BlocProvider.value(
          value: coffeeCubit,
          child: const MaterialApp(home: CoffeeView()),
        ),
      );

      expect(find.byType(CoffeePopulated), findsOneWidget);
    });

    testWidgets('renders CoffeeError for CoffeeStatus.failure', (tester) async {
      when(() => coffeeCubit.state)
          .thenReturn(CoffeeState(status: CoffeeStatus.failure));
      await tester.pumpWidget(
        BlocProvider.value(
          value: coffeeCubit,
          child: const MaterialApp(home: CoffeeView()),
        ),
      );

      expect(find.byType(CoffeeError), findsOneWidget);
    });

    testWidgets('state is cached', (tester) async {
      when<dynamic>(() => hydratedStorage.read('$CoffeeCubit')).thenReturn(
        CoffeeState(
          status: CoffeeStatus.success,
          feedCoffee: coffee,
          favoritesCoffees: const <Coffee>{},
        ).toJson(),
      );

      await tester.pumpWidget(
        BlocProvider.value(
          value: CoffeeCubit(coffeeRepository),
          child: const MaterialApp(home: CoffeeView()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CoffeePopulated), findsOneWidget);
    });

    testWidgets('triggers getRandomCoffee on tap to getRandomCoffee',
        (tester) async {
      when(() => coffeeCubit.state).thenReturn(
        CoffeeState(
          status: CoffeeStatus.success,
          favoritesCoffees: const <Coffee>{},
        ),
      );
      when(() => coffeeCubit.getRandomCoffee()).thenAnswer((_) async {});
      await tester.pumpWidget(
        BlocProvider.value(
          value: coffeeCubit,
          child: const MaterialApp(home: CoffeeView()),
        ),
      );

      await tester.tap(
        find.byKey(const Key('coffeePage_getRandomCoffe_iconButton')),
      );
      await tester.pumpAndSettle();

      verify(() => coffeeCubit.getRandomCoffee()).called(2);
    });

    testWidgets('triggers addFavoriteCoffee on tap to addFavoriteCoffee',
        (tester) async {
      when(() => coffeeCubit.state).thenReturn(
        CoffeeState(
          status: CoffeeStatus.success,
          favoritesCoffees: const <Coffee>{},
        ),
      );

      await tester.pumpWidget(
        BlocProvider.value(
          value: coffeeCubit,
          child: const MaterialApp(home: CoffeeView()),
        ),
      );

      await tester.tap(
        find.byKey(const Key('coffeePage_addFavoriteCoffee_iconButton')),
      );
      await tester.pumpAndSettle();

      verify(() => coffeeCubit.addFavoriteCoffee()).called(1);
    });
  });

  group('FavoritesCoffee Page', () {
    late coffee_api.CoffeeRepository coffeeRepository;
    late CoffeeCubit coffeeCubit;

    setUp(() async {
      coffeeRepository = MockCoffeeRepository();
      coffeeCubit = MockCoffeeCubit();
      when(() => coffeeCubit.getRandomCoffee()).thenAnswer((_) async {});
      when(() => coffeeRepository.getRandomCoffee()).thenAnswer((_) async {
        return const coffee_api.Coffee(imageUrl: coffeeImageUrl);
      });
      when(() => coffeeCubit.state).thenReturn(
        CoffeeState(
          status: CoffeeStatus.success,
          feedCoffee: const Coffee(imageUrl: coffeeImageUrl),
          favoritesCoffees: <Coffee>{const Coffee(imageUrl: coffeeImageUrl)},
        ),
      );
    });

    testWidgets('renders FavoritesCoffeeView', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: coffeeRepository,
          child: const MaterialApp(home: FavoritesCoffeesPage()),
        ),
      );
      expect(find.byType(FavoritesCoffeesView), findsOneWidget);
    });

    testWidgets('list Favorites Coffees Image', (tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: coffeeCubit,
          child: const MaterialApp(home: FavoritesCoffeesView()),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });
  });

  group('Drawer menu', () {
    late coffee_api.CoffeeRepository coffeeRepository;
    late CoffeeCubit coffeeCubit;

    setUp(() async {
      coffeeRepository = MockCoffeeRepository();
      coffeeCubit = MockCoffeeCubit();
      when(() => coffeeCubit.getRandomCoffee()).thenAnswer((_) async {});
      when(() => coffeeRepository.getRandomCoffee()).thenAnswer((_) async {
        return const coffee_api.Coffee(imageUrl: coffeeImageUrl);
      });
      when(() => coffeeCubit.state).thenReturn(
        CoffeeState(
          status: CoffeeStatus.success,
          feedCoffee: const Coffee(imageUrl: coffeeImageUrl),
          favoritesCoffees: <Coffee>{const Coffee(imageUrl: coffeeImageUrl)},
        ),
      );
    });

    testWidgets('''
      triggers coffeeRandom Page on tap
      to coffeeDrawer_CoffeeHome_iconButton''', (tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: coffeeCubit,
          child: const MaterialApp(home: CoffeeView()),
        ),
      );

      await tester.dragFrom(
          tester.getTopLeft(find.byType(MaterialApp)), Offset(300, 0));

      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('coffeeDrawer_CoffeeHome_iconButton')),
      );

      verify(() => coffeeCubit.getRandomCoffee()).called(1);
    });

    testWidgets('''
      loads FavoritesCoffeesPage Page on tap
      to coffeeDrawer_FavoritesCoffees_iconButton''', (tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: coffeeCubit,
          child: const MaterialApp(home: CoffeeView()),
        ),
      );

      await tester.dragFrom(
          tester.getTopLeft(find.byType(MaterialApp)), Offset(300, 0));

      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('coffeeDrawer_FavoritesCoffees_iconButton')),
      );

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: coffeeRepository,
          child: const MaterialApp(home: FavoritesCoffeesPage()),
        ),
      );
    });
  });
}
