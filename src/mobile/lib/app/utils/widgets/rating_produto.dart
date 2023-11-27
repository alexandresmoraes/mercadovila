import 'package:flutter/material.dart';

class RatingProduto extends StatelessWidget {
  final num rating;

  const RatingProduto({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.star,
          color: Theme.of(context).primaryColorLight,
        ),
        Icon(
          Icons.star,
          color: Theme.of(context).primaryColorLight,
        ),
        Icon(
          Icons.star,
          color: Theme.of(context).primaryColorLight,
        ),
        Icon(
          Icons.star,
          color: Theme.of(context).primaryColorLight,
        ),
        Icon(
          Icons.star,
          color: Theme.of(context).iconTheme.color,
        ),
      ],
    );
  }
}
