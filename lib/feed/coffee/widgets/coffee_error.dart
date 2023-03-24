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
          'im an coffee error widget',
          style: theme.textTheme.headlineSmall,
        ),
      ],
    );
  }
}
