import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mercadovila/app/stores/theme_store.dart';
import 'package:mercadovila/app/utils/dto/vendas/venda_dto.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_vendas_repository.dart';
import 'package:mercadovila/app/utils/widgets/card_venda.dart';
import 'package:mercadovila/app/utils/widgets/card_venda_loading.dart';
import 'package:mercadovila/app/utils/widgets/infinite_list.dart';

class MinhasComprasPage extends StatefulWidget {
  final String title;
  const MinhasComprasPage({Key? key, this.title = 'Minhas compras'}) : super(key: key);
  @override
  MinhasComprasPageState createState() => MinhasComprasPageState();
}

class MinhasComprasPageState extends State<MinhasComprasPage> {
  DateTime hoje = DateTime.now();
  late DateTime hojeDataInicial;
  late DateTime hojeDataFinal;
  late DateTime semanaDataInicial;
  late DateTime semanaDataFinal;

  MinhasComprasPageState() : super() {
    hojeDataInicial = DateTime(hoje.year, hoje.month, hoje.day).toUtc();
    hojeDataFinal = DateTime(hoje.year, hoje.month, hoje.day, 23, 59, 59, 999, 999).toUtc();
    semanaDataInicial = hojeDataInicial.subtract(Duration(days: hoje.weekday - 1)).toUtc();
    semanaDataFinal = semanaDataInicial.add(const Duration(days: 6)).toUtc();
  }

  PagingController<int, VendaDto> pagingVendasHojeController = PagingController(firstPageKey: 1);
  PagingController<int, VendaDto> pagingVendasSemanaController = PagingController(firstPageKey: 1);
  PagingController<int, VendaDto> pagingVendasTodasController = PagingController(firstPageKey: 1);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
          title: const Text("Minhas compras"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 50,
                child: AppBar(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  backgroundColor: Modular.get<ThemeStore>().isDarkModeEnable ? const Color(0xFF435276) : const Color(0xFFEDF2F6),
                  bottom: TabBar(
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 3.0,
                        color: Modular.get<ThemeStore>().isDarkModeEnable ? Theme.of(context).primaryColor : const Color(0xFFEF5656),
                      ),
                      insets: const EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    labelColor: Modular.get<ThemeStore>().isDarkModeEnable ? Colors.white : Colors.black,
                    indicatorWeight: 4,
                    unselectedLabelStyle: TextStyle(
                        fontSize: 13, color: Modular.get<ThemeStore>().isDarkModeEnable ? Colors.white : Colors.black, fontWeight: FontWeight.w400),
                    labelStyle: TextStyle(
                        fontSize: 13, color: Modular.get<ThemeStore>().isDarkModeEnable ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Modular.get<ThemeStore>().isDarkModeEnable ? Theme.of(context).primaryColor : const Color(0xFFEF5656),
                    tabs: const [
                      Tab(
                          child: Text(
                        'Hoje',
                      )),
                      Tab(
                          child: Text(
                        'Semana',
                      )),
                      Tab(
                          child: Text(
                        'Todas',
                      )),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _vendasHoje(),
                  _vendasSemana(),
                  _vendasTodas(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vendasHoje() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InfiniteList<VendaDto>(
        firstPageProgressIndicatorWidget: CardVendaLoading(),
        pagingController: pagingVendasHojeController,
        cast: VendaDto.fromJson,
        noMoreItemsBuilder: const SizedBox.shrink(),
        request: (page) async {
          return await Modular.get<IVendasRepository>().getMinhasCompras(page, hojeDataInicial, hojeDataFinal);
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
          return InkWell(
            onTap: () async {
              var refresh = await Modular.to.pushNamed<bool>('/minhas-compras/details/${item.id.toString()}');
              if (refresh ?? false) pagingVendasSemanaController.refresh();
            },
            child: CardVenda(item: item),
          );
        },
      ),
    );
  }

  Widget _vendasSemana() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InfiniteList<VendaDto>(
        firstPageProgressIndicatorWidget: CardVendaLoading(),
        pagingController: pagingVendasSemanaController,
        cast: VendaDto.fromJson,
        noMoreItemsBuilder: const SizedBox.shrink(),
        request: (page) async {
          return await Modular.get<IVendasRepository>().getMinhasCompras(page, semanaDataInicial, semanaDataFinal);
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
          return InkWell(
            onTap: () async {
              var refresh = await Modular.to.pushNamed<bool>('/minhas-compras/details/${item.id.toString()}');
              if (refresh ?? false) pagingVendasSemanaController.refresh();
            },
            child: CardVenda(item: item),
          );
        },
      ),
    );
  }

  Widget _vendasTodas() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InfiniteList<VendaDto>(
        firstPageProgressIndicatorWidget: CardVendaLoading(),
        pagingController: pagingVendasTodasController,
        cast: VendaDto.fromJson,
        noMoreItemsBuilder: const SizedBox.shrink(),
        request: (page) async {
          return await Modular.get<IVendasRepository>().getMinhasCompras(page, null, null);
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
          return InkWell(
            onTap: () async {
              var refresh = await Modular.to.pushNamed<bool>('/minhas-compras/details/${item.id.toString()}');
              if (refresh ?? false) pagingVendasSemanaController.refresh();
            },
            child: CardVenda(item: item),
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
