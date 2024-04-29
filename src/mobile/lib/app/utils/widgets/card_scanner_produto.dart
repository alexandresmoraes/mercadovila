import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CardScannerProduto extends StatelessWidget {
  final String nome;
  final String descricao;
  final double preco;
  final String unidadeMedida;
  final int quantidade;
  final String imageUrl;

  const CardScannerProduto({
    super.key,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.unidadeMedida,
    required this.quantidade,
    required this.imageUrl,
  });

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
            height: 85,
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
                      nome,
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                    Text(
                      descricao,
                      style: Theme.of(context).primaryTextTheme.displayMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    RichText(
                        text: TextSpan(text: "R\$ ", style: Theme.of(context).primaryTextTheme.displayMedium, children: [
                      TextSpan(
                        text: UtilBrasilFields.obterReal(preco, moeda: false),
                        style: Theme.of(context).primaryTextTheme.bodyLarge,
                      ),
                      TextSpan(
                        text: ' / $unidadeMedida',
                        style: Theme.of(context).primaryTextTheme.displayMedium,
                      )
                    ])),
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
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '+ $quantidade',
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
              placeholder: (context, url) => Container(
                alignment: Alignment.center,
                height: 100,
                width: 120,
                child: SpinKitThreeBounce(
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
              errorWidget: (context, url, error) => const CircleAvatar(
                radius: 100,
                child: Icon(
                  MdiIcons.cameraOff,
                  size: 70,
                  color: Colors.white,
                ),
              ),
              imageUrl: '${Modular.get<BaseOptions>().baseUrl}/api/produtos/image/$imageUrl',
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
          )
        ],
      ),
    );
  }
}
