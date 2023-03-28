import 'package:flutter/material.dart';
import 'package:my_coffees/l10n/l10n.dart';

class CoffeeError extends StatelessWidget {
  const CoffeeError({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.errorMessageTitle,
            style: theme.textTheme.headlineSmall,
          ),
          Text(
            l10n.errorMessageSubtitle,
            style: theme.textTheme.titleSmall,
          ),
          Text(
            l10n.noInternetMessage,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
