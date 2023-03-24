import 'package:flutter/material.dart';

class CoffeeLoading extends StatelessWidget {
  const CoffeeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            color: Colors.grey[200],
            height: 300,
            width: 320,
          ),
        ),
      ],
    );
  }
}
