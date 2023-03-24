import 'package:flutter/material.dart';

class CoffeeError extends StatelessWidget {
  const CoffeeError({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Sorry, but something goes wrong. Please try again later.',
          style: theme.textTheme.headlineSmall,
        ),
      ],
    );
  }
}
