import 'dart:async';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mercadovila/app/stores/theme_store.dart';
import 'package:mercadovila/app/utils/dto/produtos/produto_dto.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_produtos_repository.dart';
import 'package:mercadovila/app/utils/utils.dart';
import 'package:mercadovila/app/utils/widgets/circular_progress.dart';
import 'package:mercadovila/app/utils/widgets/infinite_list.dart';
import 'package:shimmer/shimmer.dart';

class ProdutosPage extends StatefulWidget {
  final String title;
  const ProdutosPage({Key? key, this.title = 'Produtos'}) : super(key: key);
  @override
  ProdutosPageState createState() => ProdutosPageState();
}

class ProdutosPageState extends State<ProdutosPage> {
  String? nomeFilter;
  bool isSearchVisibled = false;
  final searchController = TextEditingController();
  final searchNode = FocusNode();
  Timer? _debounce;

  PagingController<int, ProdutoDto> pagingController = PagingController(firstPageKey: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Produtos"),
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                isSearchVisibled = !isSearchVisibled;
                if (!isSearchVisibled && !isNullorEmpty(nomeFilter)) {
                  nomeFilter = "";
                  searchController.clear();
                  pagingController.refresh();
                }
                if (isSearchVisibled) {
                  searchNode.requestFocus();
                } else {
                  searchNode.unfocus();
                }
              });
            },
            icon: const Icon(MdiIcons.magnify),
          ),
          IconButton(
            onPressed: () async {
              var refresh = await Modular.to.pushNamed<bool>('/produtos/new');
              if (refresh ?? false) pagingController.refresh();
            },
            icon: const Icon(MdiIcons.plus),
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isSearchVisibled ? 70 : 0,
            child: Container(
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.only(),
              child: TextFormField(
                focusNode: searchNode,
                controller: searchController,
                onChanged: ((value) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    setState(() {
                      nomeFilter = value;
                      pagingController.refresh();
                    });
                  });
                }),
                style: Theme.of(context).primaryTextTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Buscar por nome do produto',
                  prefixIcon: Icon(
                    MdiIcons.magnify,
                    size: isSearchVisibled ? 20 : 0,
                  ),
                  contentPadding: const EdgeInsets.only(top: 10),
                ),
              ),
            ),
          ),
          Expanded(
            child: _todosProdutos(),
          ),
        ],
      ),
    );
  }

  Widget _todosProdutos() {
    final ThemeStore themeStore = Modular.get<ThemeStore>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InfiniteList<ProdutoDto>(
        firstPageProgressIndicatorWidget: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).cardTheme.color!,
            highlightColor: Colors.white,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0),
              itemCount: 10,
              itemBuilder: (_, __) => Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    height: 110,
                  ),
                ],
              ),
            ),
          ),
        ),
        pagingController: pagingController,
        request: (page) async {
          return await Modular.get<IProdutosRepository>().getProdutos(page, nomeFilter);
        },
        cast: ProdutoDto.fromJson,
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
                var refresh = await Modular.to.pushNamed<bool>('/produtos/edit/${item.id}');
                if (refresh ?? false) pagingController.refresh();
              },
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 125,
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
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                    color: themeStore.isDarkModeEnable ? const Color(0xFF373C58) : const Color(0xFFF2F5F8),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        MdiIcons.barcode,
                                        size: 18,
                                        color: Theme.of(context).primaryTextTheme.displayMedium!.color,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        item.codigoBarras,
                                        style: Theme.of(context).primaryTextTheme.displayMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
                                decoration: const BoxDecoration(
                                  color: Colors.lightBlue,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Estoque alvo ${item.estoqueAlvo}",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).primaryTextTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
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
                                      item.estoque == 0 ? "Sem estoque" : "Estoque atual ${item.estoque}",
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
                    left: 20,
                    bottom: 10,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 80,
                          child: Row(children: [
                            Icon(
                              !item.isAtivo ? MdiIcons.closeOctagon : MdiIcons.checkDecagram,
                              size: 20,
                              color: !item.isAtivo
                                  ? Colors.red
                                  : Modular.get<ThemeStore>().isDarkModeEnable
                                      ? Colors.greenAccent
                                      : Colors.green,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                item.isAtivo ? "Ativo" : "Inativo",
                                style: Theme.of(context).primaryTextTheme.displayMedium,
                              ),
                            )
                          ]),
                        )
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
