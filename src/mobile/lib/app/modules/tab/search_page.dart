import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mercadovila/app/modules/search/search_filter_store.dart';
import 'package:mercadovila/app/stores/theme_store.dart';
import 'package:mercadovila/app/utils/dto/catalogo/catalogo_dto.dart';
import 'package:mercadovila/app/utils/queries/catalogo_todos_query.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_catalogo_repository.dart';
import 'package:mercadovila/app/utils/utils.dart';
import 'package:mercadovila/app/utils/widgets/card_produto_search.dart';
import 'package:mercadovila/app/utils/widgets/infinite_list.dart';

class SearchPage extends StatefulWidget {
  final String title;
  const SearchPage({Key? key, this.title = 'Todos'}) : super(key: key);
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  String? nomeFilter;
  bool isSearchVisibled = false;
  final searchController = TextEditingController();
  final searchNode = FocusNode();
  Timer? _debounce;

  SearchPageState() : super();

  PagingController<int, CatalogoDto> pagingController = PagingController(firstPageKey: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Todos"),
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
                var refresh = await Modular.to.pushNamed<bool>('/search/search-filter');
                if (refresh ?? false) pagingController.refresh();
              },
              icon: Modular.get<ThemeStore>().isDarkModeEnable ? Image.asset('assets/filter_white.png') : Image.asset('assets/filter_black.png')),
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _todosProdutos(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _todosProdutos() {
    var store = Modular.get<SearchFilterStore>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InfiniteList<CatalogoDto>(
        pagingController: pagingController,
        request: (page) async {
          return await Modular.get<ICatalogoRepository>().getProdutosTodos(CatalogoTodosQuery(
            page: page,
            limit: 10,
            order: store.selectOrder,
            inStock: store.inStock,
            outOfStock: store.outOfStock,
            nome: nomeFilter,
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
          return CardProdutoSearch(item);
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
