import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_coffees/feed/coffee/coffee.dart';
import 'package:my_coffees/l10n/l10n.dart';

class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key, required CoffeeRepository coffeeRepository})
      : _coffeeRepository = coffeeRepository;

  final CoffeeRepository _coffeeRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _coffeeRepository,
      child: BlocProvider(
        create: (_) => CoffeeCubit(_coffeeRepository),
        child: const CoffeeAppView(),
      ),
    );
  }
}

class CoffeeAppView extends StatelessWidget {
  const CoffeeAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoffeeCubit, CoffeeState>(
      builder: (context, state) {
        return MaterialApp(
          theme: ThemeData(
            appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
            colorScheme: ColorScheme.fromSwatch(
              accentColor: const Color(0xFF13B9FF),
            ),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CoffeePage(),
        );
      },
    );
  }
}
