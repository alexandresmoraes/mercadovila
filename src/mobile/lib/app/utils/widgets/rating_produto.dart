import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_rating_repository.dart';

class RatingProduto extends StatefulWidget {
  final num rating;
  final int vendaId;
  final String produtoId;
  final bool isAtualizarRating;

  const RatingProduto({
    super.key,
    required this.rating,
    required this.vendaId,
    required this.produtoId,
    this.isAtualizarRating = true,
  });

  @override
  State<RatingProduto> createState() => _RatingProdutoState();
}

class _RatingProdutoState extends State<RatingProduto> {
  int rating = 0;

  @override
  void initState() {
    super.initState();

    rating = widget.rating.truncate();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.isAtualizarRating
            ? GestureDetector(
                onTap: () async => await adicionarRating(1),
                child: Icon(
                  Icons.star,
                  color: rating >= 1 ? Theme.of(context).primaryColorLight : Theme.of(context).iconTheme.color,
                ),
              )
            : Icon(
                Icons.star,
                color: rating >= 1 ? Theme.of(context).primaryColorLight : Theme.of(context).iconTheme.color,
              ),
        widget.isAtualizarRating
            ? GestureDetector(
                onTap: () async => await adicionarRating(2),
                child: Icon(
                  Icons.star,
                  color: rating >= 2 ? Theme.of(context).primaryColorLight : Theme.of(context).iconTheme.color,
                ),
              )
            : Icon(
                Icons.star,
                color: rating >= 2 ? Theme.of(context).primaryColorLight : Theme.of(context).iconTheme.color,
              ),
        widget.isAtualizarRating
            ? GestureDetector(
                onTap: () async => await adicionarRating(3),
                child: Icon(
                  Icons.star,
                  color: rating >= 3 ? Theme.of(context).primaryColorLight : Theme.of(context).iconTheme.color,
                ),
              )
            : Icon(
                Icons.star,
                color: rating >= 3 ? Theme.of(context).primaryColorLight : Theme.of(context).iconTheme.color,
              ),
        widget.isAtualizarRating
            ? GestureDetector(
                onTap: () async => await adicionarRating(4),
                child: Icon(
                  Icons.star,
                  color: rating >= 4 ? Theme.of(context).primaryColorLight : Theme.of(context).iconTheme.color,
                ),
              )
            : Icon(
                Icons.star,
                color: rating >= 4 ? Theme.of(context).primaryColorLight : Theme.of(context).iconTheme.color,
              ),
        widget.isAtualizarRating
            ? GestureDetector(
                onTap: () async => await adicionarRating(5),
                child: Icon(
                  Icons.star,
                  color: rating >= 5 ? Theme.of(context).primaryColorLight : Theme.of(context).iconTheme.color,
                ),
              )
            : Icon(
                Icons.star,
                color: rating >= 5 ? Theme.of(context).primaryColorLight : Theme.of(context).iconTheme.color,
              ),
      ],
    );
  }

  Future<void> adicionarRating(int newRating) async {
    try {
      setState(() {
        rating = newRating;
      });

      var ratingRepository = Modular.get<IRatingRepository>();

      await ratingRepository.adicionarRating(widget.vendaId.toString(), widget.produtoId, rating);
    } catch (e) {
      setState(() {
        rating = widget.rating.truncate();
      });
    }
  }
}
