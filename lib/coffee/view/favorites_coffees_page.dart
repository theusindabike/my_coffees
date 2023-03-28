import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_coffees/coffee/coffee.dart';
import 'package:my_coffees/l10n/l10n.dart';

class FavoritesCoffeesPage extends StatelessWidget {
  const FavoritesCoffeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CoffeeCubit(context.read<CoffeeRepository>()),
      child: const FavoritesCoffeesView(),
    );
  }
}

class FavoritesCoffeesView extends StatefulWidget {
  const FavoritesCoffeesView({
    super.key,
  });

  @override
  State<FavoritesCoffeesView> createState() => _FavoritesCoffeesViewState();
}

class _FavoritesCoffeesViewState extends State<FavoritesCoffeesView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myFavoritesCoffeesAppBarTitle),
      ),
      body: BlocBuilder<CoffeeCubit, CoffeeState>(
        builder: (context, state) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: kIsWeb ? 5 : 3,
            ),
            itemCount: state.favoritesCoffees.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.grey[200],
                  child: Image(
                    image: CachedNetworkImageProvider(
                      state.favoritesCoffees.elementAt(index).imageUrl,
                      maxWidth: 160,
                      maxHeight: 120,
                    ),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey[300],
                        ),
                      );
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
