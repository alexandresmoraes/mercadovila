import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/search/search_filter_store.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/dto/catalogo/catalogo_dto.dart';
import 'package:vilasesmo/app/utils/queries/catalogo_todos_query.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_catalogo_repository.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';
import 'package:vilasesmo/app/utils/widgets/infinite_list.dart';

class SearchPage extends StatefulWidget {
  final String title;
  const SearchPage({Key? key, this.title = 'Search'}) : super(key: key);
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  SearchPageState() : super();

  PagingController<int, CatalogoDto> pagingController = PagingController(firstPageKey: 1);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Todos"),
          actions: [
            IconButton(
                onPressed: () async {
                  var refresh = await Modular.to.pushNamed<bool>('/search/search-filter');
                  if (refresh ?? false) pagingController.refresh();
                },
                icon: Modular.get<ThemeStore>().isDarkModeEnable ? Image.asset('assets/filter_white.png') : Image.asset('assets/filter_black.png')),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _allProdutos(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _allProdutos() {
    var store = Modular.get<SearchFilterStore>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InfiniteList<CatalogoDto>(
        setTotal: store.setTotalProdutos,
        pagingController: pagingController,
        request: (page) async {
          return await Modular.get<ICatalogoRepository>().getProdutosTodos(CatalogoTodosQuery(
            page: page,
            limit: 10,
            order: store.selectOrder,
            inStock: store.inStock,
            outOfStock: store.outOfStock,
          ));
        },
        cast: CatalogoDto.fromJson,
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
              onTap: () async {
                await Modular.to.pushNamed('/produtos/details/${item.id}');
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
                                text: '${item.preco}',
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
                                      text: "${item.rating} ",
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
                  item.isAtivo
                      ? Positioned(
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
                                  color: item.estoque == 0 ? Colors.redAccent : Colors.green,
                                  borderRadius: const BorderRadius.only(
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
                              )
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
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
