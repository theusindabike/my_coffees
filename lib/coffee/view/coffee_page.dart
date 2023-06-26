import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_coffees/coffee/coffee.dart';
import 'package:my_coffees/l10n/l10n.dart';

class CoffeePage extends StatelessWidget {
  const CoffeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CoffeeCubit>(context),
      child: const CoffeeView(),
    );
  }
}

class CoffeeView extends StatefulWidget {
  const CoffeeView({super.key});

  @override
  State<CoffeeView> createState() => _CoffeeViewState();
}

class _CoffeeViewState extends State<CoffeeView> {
  @override
  void initState() {
    loadCoffeeImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myCoffeesAppBarTitle),
      ),
      drawer: NavigationDrawer(
        key: const Key('coffeeDrawer'),
        children: [
          ListTile(
            key: const Key('coffeeDrawer_CoffeeHome_iconButton'),
            title: Text(
              l10n.myCoffeesAppBarDrawerHomeTitle,
            ),
            leading: const Icon(Icons.coffee),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const CoffeePage(),
                ),
              );
            },
          ),
          ListTile(
            key: const Key('coffeeDrawer_FavoritesCoffees_iconButton'),
            title: Text(
              l10n.myCoffeesAppBarDrawerFavoriteTitle,
            ),
            leading: const Icon(Icons.favorite),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      const FavoritesCoffeesPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<CoffeeCubit, CoffeeState>(
              builder: (context, state) {
                switch (state.status) {
                  case CoffeeStatus.initial:
                    return const CoffeeEmpty();
                  case CoffeeStatus.loading:
                    return const CoffeeLoading();
                  case CoffeeStatus.success:
                    return CoffeePopulated(
                      coffee: state.feedCoffee,
                    );
                  case CoffeeStatus.failure:
                    return const CoffeeError();
                }
              },
            ),
            const SizedBox(height: 10),
            const CoffeeActionsRow(),
          ],
        ),
      ),
    );
  }

  Future<void> loadCoffeeImage() async {
    await context.read<CoffeeCubit>().getRandomCoffee();
  }
}

class CoffeeActionsRow extends StatelessWidget {
  const CoffeeActionsRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CoffeeActionButton(
          key: const Key('coffeePage_getRandomCoffe_iconButton'),
          icon: const Icon(Icons.shuffle),
          action: context.read<CoffeeCubit>().getRandomCoffee,
          tooltipText: l10n.getAnotherCoffeeImageTooltipText,
        ),
        CoffeeActionButton(
          key: const Key('coffeePage_addFavoriteCoffee_iconButton'),
          icon: const Icon(Icons.favorite),
          action: context.read<CoffeeCubit>().addFavoriteCoffee,
          tooltipText: l10n.addFavoriteCoffeeTooltipText,
        ),
      ],
    );
  }
}

class CoffeeActionButton extends StatelessWidget {
  const CoffeeActionButton({
    super.key,
    required this.icon,
    required this.action,
    String? tooltipText,
  }) : tooltipText = tooltipText ?? '';

  final Icon icon;
  final FutureOr<void> Function() action;
  final String? tooltipText;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.lightBlue,
        shape: CircleBorder(),
      ),
      child: IconButton(
        color: Colors.white,
        icon: icon,
        tooltip: tooltipText,
        iconSize: 28,
        onPressed: () async {
          await action();
        },
      ),
    );
  }
}
