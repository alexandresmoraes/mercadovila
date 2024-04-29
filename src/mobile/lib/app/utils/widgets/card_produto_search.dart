import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mercadovila/app/utils/controllers/favorito_controller.dart';
import 'package:mercadovila/app/utils/dto/catalogo/catalogo_dto.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_favoritos_repository.dart';
import 'package:mercadovila/app/utils/widgets/card_count_produto.dart';

class CardProdutoSearch extends StatelessWidget {
  final FavoritoController favoritoController = Modular.get<FavoritoController>();
  final CatalogoDto item;

  CardProdutoSearch(this.item, {super.key}) {
    favoritoController.isFavorito = item.isFavorito;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: InkWell(
        onTap: () async {
          await Modular.to.pushNamed('/produtos/details/${item.produtoId}');
        },
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 110,
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
                        item.nome,
                        style: Theme.of(context).primaryTextTheme.bodyLarge,
                      ),
                      Text(
                        item.descricao,
                        style: Theme.of(context).primaryTextTheme.displayMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      RichText(
                          text: TextSpan(text: "R\$ ", style: Theme.of(context).primaryTextTheme.displayMedium, children: [
                        TextSpan(
                          text: UtilBrasilFields.obterReal(item.preco.toDouble(), moeda: false),
                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: ' / ${item.unidadeMedida}',
                          style: Theme.of(context).primaryTextTheme.displayMedium,
                        )
                      ])),
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
                                text: "${UtilBrasilFields.obterReal(item.rating.toDouble(), moeda: false, decimal: 1)} ",
                                style: Theme.of(context).primaryTextTheme.bodyLarge,
                                children: [
                                  TextSpan(
                                    text: '|',
                                    style: Theme.of(context).primaryTextTheme.displayMedium,
                                  ),
                                  TextSpan(
                                    text: ' ${item.ratingCount} ratings',
                                    style: Theme.of(context).primaryTextTheme.displayLarge,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                      color: !item.isDisponivel() ? Colors.redAccent : Colors.green,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.getDisponiveis(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).primaryTextTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Observer(builder: (_) {
                    return IconButton(
                      onPressed: () async {
                        var favoritoRepository = Modular.get<IFavoritosRepository>();
                        try {
                          if (favoritoController.isFavorito) {
                            favoritoController.isFavorito = !favoritoController.isFavorito;
                            await favoritoRepository.removerFavorito(item.produtoId);
                          } else {
                            favoritoController.isFavorito = !favoritoController.isFavorito;
                            await favoritoRepository.adicionarFavorito(item.produtoId);
                          }
                        } catch (e) {
                          favoritoController.isFavorito = !favoritoController.isFavorito;
                        }
                      },
                      icon: favoritoController.isFavorito ? Image.asset('assets/fav_red.png') : Image.asset('assets/fav_grey.png'),
                    );
                  })
                ],
              ),
            ),
            Observer(builder: (_) {
              return CardCountProduto(
                produtoId: item.produtoId,
                estoqueDisponivel: item.estoque,
                isAtivo: item.isAtivo,
              );
            }),
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
                imageUrl: '${Modular.get<BaseOptions>().baseUrl}/api/produtos/image/${item.imageUrl}',
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
      ),
    );
  }
}
