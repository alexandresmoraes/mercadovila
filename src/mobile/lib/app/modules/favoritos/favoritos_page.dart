import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/utils/dto/favoritos/favorito_item_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_favoritos_repository.dart';
import 'package:vilasesmo/app/utils/widgets/card_count_produto.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';
import 'package:vilasesmo/app/utils/widgets/infinite_list.dart';

class FavoritosPage extends StatefulWidget {
  final String title;
  const FavoritosPage({Key? key, this.title = 'Favoritos'}) : super(key: key);
  @override
  FavoritosPageState createState() => FavoritosPageState();
}

class FavoritosPageState extends State<FavoritosPage> {
  PagingController<int, FavoritoItemDto> pagingController = PagingController(firstPageKey: 1);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Favoritos"),
        ),
        body: Column(
          children: [
            Expanded(
              child: _todosFavoritos(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _todosFavoritos() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InfiniteList<FavoritoItemDto>(
        pagingController: pagingController,
        request: (page) async {
          return await Modular.get<IFavoritosRepository>().getFavoritos(page);
        },
        cast: FavoritoItemDto.fromJson,
        noMoreItemsBuilder: const SizedBox.shrink(),
        emptyBuilder: (_) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/empty_list.png',
                  width: 300,
                  height: 300,
                ),
              ],
            ),
          );
        },
        itemBuilder: (context, item, index) {
          return Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: InkWell(
              onTap: () {
                //
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
                        padding: const EdgeInsets.only(top: 10, left: 120),
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
                                text: UtilBrasilFields.obterReal(item.preco, moeda: false),
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
                            color: !item.isDisponivel() ? Colors.redAccent : Colors.green,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
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
                        IconButton(
                          onPressed: () async {
                            showCupertinoModalPopup<void>(
                              context: context,
                              builder: (BuildContext context) => CupertinoAlertDialog(
                                title: const Text('Atenção!'),
                                content: const Text('Deseja remover o favorito?'),
                                actions: <CupertinoDialogAction>[
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    onPressed: () async {
                                      Modular.to.pop();
                                      var favoritoRepository = Modular.get<IFavoritosRepository>();
                                      await favoritoRepository.removerFavorito(item.produtoId);
                                      pagingController.refresh();
                                    },
                                    child: const Text(
                                      'Sim',
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      Modular.to.pop();
                                    },
                                    child: const Text('Não'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: item.isFavorito ? Image.asset('assets/fav_red.png') : Image.asset('assets/fav_grey.png'),
                        )
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
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
