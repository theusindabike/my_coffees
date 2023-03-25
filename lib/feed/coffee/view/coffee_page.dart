import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_coffees/feed/coffee/coffee.dart';

class CoffeePage extends StatelessWidget {
  const CoffeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CoffeeCubit(context.read<CoffeeRepository>()),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Coffees'),
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
                      coffee: state.coffee,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CoffeeActionButton(
          icon: const Icon(Icons.shuffle),
          action: context.read<CoffeeCubit>().getRandomCoffee,
          tooltipText: 'Get another coffe image',
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
  final Future Function() action;
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
