import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/compras/carrinho_compras_store.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/dto/compras/carrinho_compras_dto.dart';
import 'package:vilasesmo/app/utils/widgets/card_produto_carrinho_compras_count.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';

class CardProdutoCarrinhoCompras extends StatefulWidget {
  final CarrinhoComprasItemDto item;

  const CardProdutoCarrinhoCompras({
    super.key,
    required this.item,
  });

  @override
  CardProdutoCarrinhoComprasState createState() => CardProdutoCarrinhoComprasState();
}

class CardProdutoCarrinhoComprasState extends State<CardProdutoCarrinhoCompras> {
  bool isPrecoMedioSugerido = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 120),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.nome,
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                    Text(
                      widget.item.descricao,
                      style: Theme.of(context).primaryTextTheme.displayMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    RichText(
                        text: TextSpan(text: "R\$ ", style: Theme.of(context).primaryTextTheme.displayMedium, children: [
                      TextSpan(
                        text: '${widget.item.preco}',
                        style: Theme.of(context).primaryTextTheme.bodyLarge,
                      ),
                      TextSpan(
                        text: ' / ${widget.item.unidadeMedida}',
                        style: Theme.of(context).primaryTextTheme.displayMedium,
                      )
                    ])),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Preço pago",
                                      style: Theme.of(context).primaryTextTheme.displayMedium,
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                                      margin: const EdgeInsets.only(top: 5, bottom: 15),
                                      padding: const EdgeInsets.only(),
                                      child: TextFormField(
                                        style: Theme.of(context).primaryTextTheme.bodyLarge,
                                        autocorrect: true,
                                        initialValue: "${widget.item.preco}",
                                        onChanged: (text) {},
                                        decoration: InputDecoration(
                                          fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                              ? Theme.of(context).inputDecorationTheme.fillColor
                                              : Theme.of(context).scaffoldBackgroundColor,
                                          hintText: 'Preço pago',
                                          contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Preço sugerido",
                                      style: Theme.of(context).primaryTextTheme.displayMedium,
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                                      margin: const EdgeInsets.only(top: 5, bottom: 15),
                                      padding: const EdgeInsets.only(),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        style: Theme.of(context).primaryTextTheme.bodyLarge,
                                        autocorrect: true,
                                        initialValue: "${widget.item.preco}",
                                        onChanged: (text) {
                                          try {
                                            widget.item.preco = double.parse(text);
                                            print(widget.item.preco);
                                          } catch (e) {
                                            print('A string não é um número válido. $text');
                                          }
                                        },
                                        decoration: InputDecoration(
                                          fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                              ? Theme.of(context).inputDecorationTheme.fillColor
                                              : Theme.of(context).scaffoldBackgroundColor,
                                          hintText: 'Preço sugerido',
                                          contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        isPrecoMedioSugerido = !isPrecoMedioSugerido;
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Icon(
                            isPrecoMedioSugerido ? Icons.check_box : Icons.check_box_outline_blank,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              'Usar preço médio sugerido.',
                              style: Theme.of(context).primaryTextTheme.displayMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 20,
                  width: 100,
                  decoration: BoxDecoration(
                    color: !widget.item.isDisponivel() ? Colors.redAccent : Colors.green,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.item.getDisponiveis(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).primaryTextTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CardProdutoCarrinhoComprasCount(
            quantidade: widget.item.quantidade,
            onAdicionar: () {
              Modular.get<CarrinhoComprasStore>().addCarrinhoComprasItemExistente(widget.item.produtoId);
              setState(() {});
            },
            onRemover: () {
              Modular.get<CarrinhoComprasStore>().removerCarrinhoComprasItem(widget.item.produtoId);
              setState(() {});
            },
          ),
          Positioned(
            left: 0,
            top: -20,
            child: CachedNetworkImage(
              placeholder: (context, url) => const SizedBox(
                width: 120,
                height: 100,
                child: CircularProgress(),
              ),
              errorWidget: (context, url, error) => const SizedBox(
                width: 120,
                height: 100,
                child: CircleAvatar(
                  radius: 50,
                  child: Icon(
                    MdiIcons.cameraOff,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              imageUrl: '${Modular.get<BaseOptions>().baseUrl}/api/produtos/image/${widget.item.imageUrl}',
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                    ),
                  ),
                  height: 100,
                  width: 120,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
