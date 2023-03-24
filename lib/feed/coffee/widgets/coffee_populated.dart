import 'package:flutter/material.dart';
import 'package:my_coffees/feed/coffee/coffee.dart';

class CoffeePopulated extends StatelessWidget {
  const CoffeePopulated({
    super.key,
    required this.coffee,
    // required this.onRefresh,
  });

  final Coffee coffee;
  // final ValueGetter<Future<void>> onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.network(
          coffee.imageUrl,
          fit: BoxFit.contain,
        )
      ],
    );
  }
}
