import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardProdutoCarrinhoComprasCount extends StatelessWidget {
  final int quantidade;

  const CardProdutoCarrinhoComprasCount({
    Key? key,
    required this.quantidade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (quantidade == 0) {
      return Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10),
              bottomLeft: Radius.zero,
            ),
          ),
          child: IconButton(
            padding: const EdgeInsets.all(0),
            visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
            onPressed: () async {
              //TODO
            },
            icon: Icon(
              Icons.add,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
        ),
      );
    }

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
            colors: [
              Theme.of(context).primaryColorLight,
              Theme.of(context).primaryColor,
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            bottomLeft: Radius.zero,
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
                onPressed: () async {
                  showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                      title: const Icon(Icons.question_answer),
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                          isDestructiveAction: true,
                          onPressed: () async {
                            Modular.to.pop();
                            // TODO
                          },
                          child: const Text(
                            'Remover',
                          ),
                        ),
                        CupertinoActionSheetAction(
                          isDefaultAction: true,
                          onPressed: () {
                            Modular.to.pop();
                          },
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  FontAwesomeIcons.minus,
                  size: 11,
                  color: Theme.of(context).primaryTextTheme.bodySmall!.color,
                )),
            Text(
              "$quantidade",
              style: Theme.of(context)
                  .primaryTextTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).primaryTextTheme.bodySmall!.color),
            ),
            IconButton(
              padding: const EdgeInsets.all(0),
              visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
              onPressed: () async {
                // TODO
              },
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
