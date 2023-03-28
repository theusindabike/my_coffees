import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_coffees/coffee/coffee.dart';

class FavoritesCoffeePage extends StatelessWidget {
  const FavoritesCoffeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CoffeeCubit(context.read<CoffeeRepository>()),
      child: const FavoritesCoffeeView(),
    );
  }
}

class FavoritesCoffeeView extends StatefulWidget {
  const FavoritesCoffeeView({
    super.key,
  });

  @override
  State<FavoritesCoffeeView> createState() => _FavoritesCoffeeViewState();
}

class _FavoritesCoffeeViewState extends State<FavoritesCoffeeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites Coffees'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              CoffeeCubit(context.read<CoffeeRepository>())
                  .cleanAllFavoritesCoffees();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
        ],
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
