import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardCountProduto extends StatefulWidget {
  final int quantidade;
  final VoidCallback increment;
  final VoidCallback decrement;

  const CardCountProduto({
    Key? key,
    required this.quantidade,
    required this.increment,
    required this.decrement,
  }) : super(key: key);

  @override
  CardCountProdutoState createState() => CardCountProdutoState();
}

class CardCountProdutoState extends State<CardCountProduto> {
  @override
  Widget build(BuildContext context) {
    if (widget.quantidade == 0) {
      return Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerTheme.color,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
          child: IconButton(
            padding: const EdgeInsets.all(0),
            visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
            onPressed: widget.increment,
            icon: Icon(
              Icons.add,
              color: Theme.of(context).primaryTextTheme.bodySmall!.color,
            ),
          ),
        ),
      );
    } else {
      return Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          height: 28,
          width: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              stops: const [0, .90],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor],
            ),
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  padding: const EdgeInsets.all(0),
                  visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                  onPressed: widget.decrement,
                  icon: Icon(
                    FontAwesomeIcons.minus,
                    size: 11,
                    color: Theme.of(context).primaryTextTheme.bodySmall!.color,
                  )),
              Text(
                "${widget.quantidade}",
                style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryTextTheme.bodySmall!.color),
              ),
              IconButton(
                padding: const EdgeInsets.all(0),
                visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                onPressed: widget.increment,
                icon: Icon(
                  FontAwesomeIcons.plus,
                  size: 11,
                  color: Theme.of(context).primaryTextTheme.bodySmall!.color,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
