import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_api/coffee_api.dart' as coffee_api;
import 'package:coffee_api/coffee_api.dart' hide Coffee;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_coffees/coffee/coffee.dart';

import '../../../helpers/helpers.dart';

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

    // testWidgets('state is cached', (tester) async {
    //   when<dynamic>(() => hydratedStorage.read('$CoffeeCubit')).thenReturn(
    //     CoffeeState(
    //       status: CoffeeStatus.success,
    //       feedCoffee: coffee,
    //       favoritesCoffees: const <Coffee>{},
    //     ).toJson(),
    //   );
    //   await tester.pumpWidget(
    //     BlocProvider.value(
    //       value: coffeeCubit,
    //       child: const MaterialApp(home: CoffeeView()),
    //     ),
    //   );
    //   expect(find.byType(CoffeePopulated), findsOneWidget);
    // });

    testWidgets('triggers getRandomCoffee on tap to getRandomCoffee',
        (tester) async {
      when(() => CoffeePage);
      when(() => coffeeCubit.state).thenReturn(
        CoffeeState(
          status: CoffeeStatus.success,
          favoritesCoffees: Set<Coffee>(),
        ),
      );
      when(() => coffeeCubit.getRandomCoffee()).thenAnswer((_) async {});
      await tester.pumpWidget(
        BlocProvider.value(
          value: coffeeCubit,
          child: const MaterialApp(home: CoffeeView()),
        ),
      );

      await tester
          .tap(find.byKey(const Key('coffeePage_getRandomCoffe_iconButton')));
      await tester.pumpAndSettle();

      verify(() => coffeeCubit.getRandomCoffee()).called(2);
    });

    // testWidgets('''
    //     navigates to favoritesCoffeesPage
    //     when favorite drawer button is tapped''', (tester) async {
    //   when(() => coffeeCubit.state).thenReturn(CoffeeState());
    //   await tester.pumpWidget(
    //     BlocProvider.value(
    //       value: coffeeCubit,
    //       child: const MaterialApp(home: CoffeeView()),
    //     ),
    //   );
    //   await tester.tap(find.byType(FloatingActionButton));
    //   await tester.pumpAndSettle();
    //   expect(find.byType(FavoritesCoffeePage), findsOneWidget);
    // });
    // testWidgets('renders WeatherLoading for WeatherStatus.loading',
    //     (tester) async {
    //   when(() => weatherCubit.state).thenReturn(
    //     WeatherState(
    //       status: WeatherStatus.loading,
    //     ),
    //   );
    //   await tester.pumpWidget(
    //     BlocProvider.value(
    //       value: weatherCubit,
    //       child: MaterialApp(home: WeatherView()),
    //     ),
    //   );
    //   expect(find.byType(WeatherLoading), findsOneWidget);
    // });

    // testWidgets('renders WeatherPopulated for WeatherStatus.success',
    //     (tester) async {
    //   when(() => weatherCubit.state).thenReturn(
    //     WeatherState(
    //       status: WeatherStatus.success,
    //       weather: weather,
    //     ),
    //   );
    //   await tester.pumpWidget(
    //     BlocProvider.value(
    //       value: weatherCubit,
    //       child: MaterialApp(home: WeatherView()),
    //     ),
    //   );
    //   expect(find.byType(WeatherPopulated), findsOneWidget);
    // });

    // testWidgets('renders WeatherError for WeatherStatus.failure',
    //     (tester) async {
    //   when(() => weatherCubit.state).thenReturn(
    //     WeatherState(
    //       status: WeatherStatus.failure,
    //     ),
    //   );
    //   await tester.pumpWidget(
    //     BlocProvider.value(
    //       value: weatherCubit,
    //       child: MaterialApp(home: WeatherView()),
    //     ),
    //   );
    //   expect(find.byType(WeatherError), findsOneWidget);
    // });

    // testWidgets('state is cached', (tester) async {
    //   when<dynamic>(() => hydratedStorage.read('$WeatherCubit')).thenReturn(
    //     WeatherState(
    //       status: WeatherStatus.success,
    //       weather: weather,
    //       temperatureUnits: TemperatureUnits.fahrenheit,
    //     ).toJson(),
    //   );
    //   await tester.pumpWidget(
    //     BlocProvider.value(
    //       value: WeatherCubit(MockWeatherRepository()),
    //       child: MaterialApp(home: WeatherView()),
    //     ),
    //   );
    //   expect(find.byType(WeatherPopulated), findsOneWidget);
    // });

    // testWidgets('navigates to SettingsPage when settings icon is tapped',
    //     (tester) async {
    //   when(() => weatherCubit.state).thenReturn(WeatherState());
    //   await tester.pumpWidget(
    //     BlocProvider.value(
    //       value: weatherCubit,
    //       child: MaterialApp(home: WeatherView()),
    //     ),
    //   );
    //   await tester.tap(find.byType(IconButton));
    //   await tester.pumpAndSettle();
    //   expect(find.byType(SettingsPage), findsOneWidget);
    // });

    // testWidgets('navigates to SearchPage when search button is tapped',
    //     (tester) async {
    //   when(() => weatherCubit.state).thenReturn(WeatherState());
    //   await tester.pumpWidget(
    //     BlocProvider.value(
    //       value: weatherCubit,
    //       child: MaterialApp(home: WeatherView()),
    //     ),
    //   );
    //   await tester.tap(find.byType(FloatingActionButton));
    //   await tester.pumpAndSettle();
    //   expect(find.byType(SearchPage), findsOneWidget);
    // });

    // testWidgets('calls updateTheme when whether changes', (tester) async {
    //   whenListen(
    //     weatherCubit,
    //     Stream<WeatherState>.fromIterable([
    //       WeatherState(),
    //       WeatherState(status: WeatherStatus.success, weather: weather),
    //     ]),
    //   );
    //   when(() => weatherCubit.state).thenReturn(
    //     WeatherState(
    //       status: WeatherStatus.success,
    //       weather: weather,
    //     ),
    //   );
    //   await tester.pumpWidget(
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider.value(value: themeCubit),
    //         BlocProvider.value(value: weatherCubit),
    //       ],
    //       child: MaterialApp(home: WeatherView()),
    //     ),
    //   );
    //   verify(() => themeCubit.updateTheme(weather)).called(1);
    // });

    // testWidgets('triggers refreshWeather on pull to refresh', (tester) async {
    //   when(() => weatherCubit.state).thenReturn(
    //     WeatherState(
    //       status: WeatherStatus.success,
    //       weather: weather,
    //     ),
    //   );
    //   when(() => weatherCubit.refreshWeather()).thenAnswer((_) async {});
    //   await tester.pumpWidget(
    //     BlocProvider.value(
    //       value: weatherCubit,
    //       child: MaterialApp(home: WeatherView()),
    //     ),
    //   );
    //   await tester.fling(
    //     find.text('London'),
    //     const Offset(0, 500),
    //     1000,
    //   );
    //   await tester.pumpAndSettle();
    //   verify(() => weatherCubit.refreshWeather()).called(1);
    // });

    // testWidgets('triggers fetch on search pop', (tester) async {
    //   when(() => weatherCubit.state).thenReturn(WeatherState());
    //   when(() => weatherCubit.fetchWeather(any())).thenAnswer((_) async {});
    //   await tester.pumpWidget(
    //     BlocProvider.value(
    //       value: weatherCubit,
    //       child: MaterialApp(home: WeatherView()),
    //     ),
    //   );
    //   await tester.tap(find.byType(FloatingActionButton));
    //   await tester.pumpAndSettle();
    //   await tester.enterText(find.byType(TextField), 'Chicago');
    //   await tester.tap(find.byKey(const Key('searchPage_search_iconButton')));
    //   await tester.pumpAndSettle();
    //   verify(() => weatherCubit.fetchWeather('Chicago')).called(1);
    // });
  });
}
