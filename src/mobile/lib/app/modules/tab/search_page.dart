import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vilasesmo/app/modules/search/search_filter_store.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/dto/catalogo/catalogo_dto.dart';
import 'package:vilasesmo/app/utils/queries/catalogo_todos_query.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_catalogo_repository.dart';
import 'package:vilasesmo/app/utils/widgets/card_produto_search.dart';
import 'package:vilasesmo/app/utils/widgets/infinite_list.dart';

class SearchPage extends StatefulWidget {
  final String title;
  const SearchPage({Key? key, this.title = 'Todos'}) : super(key: key);
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
                icon: Modular.get<ThemeStore>().isDarkModeEnable
                    ? Image.asset('assets/filter_white.png')
                    : Image.asset('assets/filter_black.png')),
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
