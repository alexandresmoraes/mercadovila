import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vilasesmo/app/modules/carrinho/carrinho_store.dart';
import 'package:vilasesmo/app/utils/widgets/card_count_produto_controller.dart';

class CardCountProduto extends StatelessWidget {
  final controller = Modular.get<CardCountProdutoController>();
  final String produtoId;
  final int estoqueDisponivel;
  final bool isAtivo;
  final bool isTop;

  CardCountProduto({
    super.key,
    required this.produtoId,
    required this.estoqueDisponivel,
    required this.isAtivo,
    this.isTop = false,
  }) {
    controller.produtoId = produtoId;
    controller.quantidade = Modular.get<CarrinhoStore>().getCarrinhoItemQuantidade(produtoId);
    controller.estoqueDisponivel = estoqueDisponivel;
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      if (controller.estoqueDisponivel == 0 && controller.quantidade == 0) {
        return const SizedBox.shrink();
      } else if (controller.quantidade == 0) {
        return Positioned(
          top: isTop ? 0 : null,
          bottom: isTop ? null : 0,
          right: 0,
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                bottomRight: isTop ? Radius.zero : const Radius.circular(10),
                topLeft: isTop ? Radius.zero : const Radius.circular(10),
                bottomLeft: isTop ? const Radius.circular(10) : Radius.zero,
              ),
            ),
            child: IconButton(
              padding: const EdgeInsets.all(0),
              visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
              onPressed: () async {
                controller.adicionarCarrinhoItem();
              },
              icon: Icon(
                Icons.add,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
        );
      } else {
        return Positioned(
          top: isTop ? 0 : null,
          bottom: isTop ? null : 0,
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
                  !isAtivo || controller.quantidade > controller.estoqueDisponivel ? Colors.redAccent : Theme.of(context).primaryColorLight,
                  controller.quantidade < controller.estoqueDisponivel && isAtivo
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).iconTheme.color!
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomRight: isTop ? Radius.zero : const Radius.circular(10),
                topLeft: isTop ? Radius.zero : const Radius.circular(10),
                bottomLeft: isTop ? const Radius.circular(10) : Radius.zero,
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
                      if (controller.quantidade == 1) {
                        showCupertinoModalPopup<void>(
                          context: context,
                          builder: (BuildContext context) => CupertinoActionSheet(
                            title: const Icon(Icons.question_answer),
                            actions: <Widget>[
                              CupertinoActionSheetAction(
                                isDestructiveAction: true,
                                onPressed: () async {
                                  Modular.to.pop();
                                  await controller.removerCarrinhoItem();
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
                      } else {
                        controller.removerCarrinhoItem();
                      }
                    },
                    icon: Icon(
                      FontAwesomeIcons.minus,
                      size: 11,
                      color: Theme.of(context).primaryTextTheme.bodySmall!.color,
                    )),
                Text(
                  "${controller.quantidade}",
                  style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryTextTheme.bodySmall!.color),
                ),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                  onPressed: () async {
                    controller.adicionarCarrinhoItem();
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
    });
  }
}
