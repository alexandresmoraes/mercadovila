import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/utils/dto/compras/compra_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_compras_repository.dart';
import 'package:vilasesmo/app/utils/widgets/card_compra.dart';
import 'package:vilasesmo/app/utils/widgets/infinite_list.dart';

class ComprasPage extends StatefulWidget {
  final String title;
  const ComprasPage({Key? key, this.title = 'Compras'}) : super(key: key);
  @override
  ComprasPageState createState() => ComprasPageState();
}

class ComprasPageState extends State<ComprasPage> {
  PagingController<int, CompraDto> pagingController = PagingController(firstPageKey: 1);

  ComprasPageState() : super();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
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
            centerTitle: true,
            title: const Text("Compras"),
            actions: [
              IconButton(
                onPressed: () async {
                  var refresh = await Modular.to.pushNamed<bool>('/compras/carrinho');
                  if (refresh ?? false) pagingController.refresh();
                },
                icon: const Icon(MdiIcons.plus),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InfiniteList<CompraDto>(
                    pagingController: pagingController,
                    cast: CompraDto.fromJson,
                    noMoreItemsBuilder: const SizedBox.shrink(),
                    request: (page) async {
                      return await Modular.get<IComprasRepository>().getCompras(page, null, null);
                    },
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
                      return CardCompra(item: item);
                    },
                  ),
                ),
              ),
            ],
          ),
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
