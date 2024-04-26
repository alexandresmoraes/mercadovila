import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mercadovila/app/utils/dto/produtos/lista_compras_dto.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_produtos_repository.dart';
import 'package:mercadovila/app/utils/widgets/card_lista_compra.dart';
import 'package:mercadovila/app/utils/widgets/infinite_list.dart';
import 'package:shimmer/shimmer.dart';

class ListaComprasPage extends StatefulWidget {
  final String title;
  const ListaComprasPage({Key? key, this.title = 'Lista de compras'}) : super(key: key);
  @override
  ListaComprasPageState createState() => ListaComprasPageState();
}

class ListaComprasPageState extends State<ListaComprasPage> {
  ListaComprasPageState() : super();

  PagingController<int, ListaComprasDto> pagingController = PagingController(firstPageKey: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onTap: () {
            Modular.to.pop();
          },
          child: const Align(
            alignment: Alignment.center,
            child: Icon(MdiIcons.arrowLeft),
          ),
        ),
        title: const Text("Lista de compras"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InfiniteList<ListaComprasDto>(
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
            return await Modular.get<IProdutosRepository>().getListaCompra(page);
          },
          cast: ListaComprasDto.fromJson,
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
            return CardListaCompra(item: item);
          },
        ),
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
