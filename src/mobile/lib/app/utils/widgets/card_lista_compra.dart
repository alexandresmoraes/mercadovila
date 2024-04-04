import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/dto/produtos/lista_compras_dto.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';

class CardListaCompra extends StatefulWidget {
  final ListaComprasDto item;

  const CardListaCompra({
    super.key,
    required this.item,
  });

  @override
  CardListaCompraState createState() => CardListaCompraState();
}

class CardListaCompraState extends State<CardListaCompra> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return _card();
  }

  Widget _card() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: InkWell(
        onTap: () async {
          setState(() {
            isChecked = !isChecked;
          });
        },
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 115,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 130),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              size: 18,
                              color: Theme.of(context).primaryColorLight,
                            ),
                            RichText(
                              text: TextSpan(
                                text: "${UtilBrasilFields.obterReal(widget.item.rating.toDouble(), moeda: false, decimal: 1)} ",
                                style: Theme.of(context).primaryTextTheme.bodyLarge,
                                children: [
                                  TextSpan(
                                    text: '|',
                                    style: Theme.of(context).primaryTextTheme.displayMedium,
                                  ),
                                  TextSpan(
                                    text: ' ${widget.item.ratingCount} ratings',
                                    style: Theme.of(context).primaryTextTheme.displayLarge,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 80,
                            child: Row(children: [
                              Icon(
                                MdiIcons.checkDecagram,
                                size: 20,
                                color: Modular.get<ThemeStore>().isDarkModeEnable ? Colors.greenAccent : Colors.green,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Ativo",
                                  style: Theme.of(context).primaryTextTheme.displayMedium,
                                ),
                              )
                            ]),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            isChecked
                ? const SizedBox.shrink()
                : Positioned(
                    right: 0,
                    top: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 20,
                          width: 150,
                          decoration: const BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sugestão de compra ${widget.item.estoqueAlvo - widget.item.estoque}",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).primaryTextTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                errorWidget: (context, url, error) => const CircleAvatar(
                  radius: 100,
                  child: Icon(
                    MdiIcons.cameraOff,
                    size: 70,
                    color: Colors.white,
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
            Positioned(
              right: 10,
              bottom: 40,
              child: Icon(
                isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
