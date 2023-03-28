import 'package:flutter/material.dart';

class CoffeeError extends StatelessWidget {
  const CoffeeError({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Something went wrong',
            style: theme.textTheme.headlineSmall,
          ),
          Text(
            'Please, check your internet conection an try again later',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
