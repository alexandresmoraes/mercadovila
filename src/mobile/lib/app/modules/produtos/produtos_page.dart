import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/carrinho/carrinho_page.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/dto/produtos/produto_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_produtos_repository.dart';
import 'package:vilasesmo/app/utils/widgets/infinite_list.dart';

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
  Timer? _debounce;

  PagingController<int, ProdutoDto> pagingController = PagingController(firstPageKey: 1);

  final List<Product> _productList = [
    Product(imagePath: "assets/lamb.png"),
    Product(imagePath: "assets/wheat.png"),
    Product(imagePath: "assets/bakery.png"),
    Product(imagePath: "assets/lamb.png"),
    Product(imagePath: "assets/wheat.png"),
    Product(imagePath: "assets/cheese.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Produtos"),
          actions: [
            IconButton(
              onPressed: () async {
                setState(() {
                  isSearchVisibled = !isSearchVisibled;
                  nomeFilter = "";
                  searchController.clear();
                  if (!isSearchVisibled) pagingController.refresh();
                });
              },
              icon: const Icon(MdiIcons.magnify),
            ),
            IconButton(
              onPressed: () async {
                await Modular.to.pushNamed('/produtos/edit');
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
              child: _allProdutos(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _allProdutos() {
    final ThemeStore themeStore = Modular.get<ThemeStore>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InfiniteList<ProdutoDto>(
        pagingController: pagingController,
        request: (page) async {
          return await Modular.get<IProdutosRepository>().getProdutos(page, nomeFilter);
        },
        cast: ProdutoDto.fromJson,
        noMoreItemsBuilder: const SizedBox.shrink(),
        emptyBuilder: Center(
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
        ),
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
                Modular.to.pushNamed('/produtos/edit/${item.id}');
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
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                color: themeStore.isDarkModeEnable ? const Color(0xFF373C58) : const Color(0xFFF2F5F8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              child: Text(
                                item.id,
                                style: Theme.of(context).primaryTextTheme.displayMedium,
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
                          decoration: const BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Estoque alvo ${item.estoqueAlvo}",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).primaryTextTheme.bodySmall,
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 20,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Estoque ${item.estoque}",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).primaryTextTheme.bodySmall,
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: -20,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('${_productList[index].imagePath}'),
                        ),
                      ),
                      height: 100,
                      width: 120,
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
