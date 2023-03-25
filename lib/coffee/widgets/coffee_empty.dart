import 'package:flutter/material.dart';

class CoffeeEmpty extends StatelessWidget {
  const CoffeeEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'im an coffee empty widget',
          style: theme.textTheme.headlineSmall,
        ),
      ],
    );
  }
}
