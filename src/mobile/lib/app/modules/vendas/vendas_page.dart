import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mercadovila/app/stores/theme_store.dart';
import 'package:mercadovila/app/utils/dto/vendas/venda_dto.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_vendas_repository.dart';
import 'package:mercadovila/app/utils/utils.dart';
import 'package:mercadovila/app/utils/widgets/card_venda.dart';
import 'package:mercadovila/app/utils/widgets/card_venda_loading.dart';
import 'package:mercadovila/app/utils/widgets/infinite_list.dart';

class VendasPage extends StatefulWidget {
  final String title;
  const VendasPage({Key? key, this.title = 'Vendas'}) : super(key: key);
  @override
  VendasPageState createState() => VendasPageState();
}

class VendasPageState extends State<VendasPage> with SingleTickerProviderStateMixin {
  String? compradorNomeFilter;
  bool isSearchVisibled = false;

  final searchController = TextEditingController();
  final searchNode = FocusNode();
  Timer? debounce;

  DateTime hoje = DateTime.now();
  late DateTime hojeDataInicial;
  late DateTime hojeDataFinal;
  late DateTime semanaDataInicial;
  late DateTime semanaDataFinal;

  late TabController tabController;

  PagingController<int, VendaDto> pagingVendasHojeController = PagingController(firstPageKey: 1);
  PagingController<int, VendaDto> pagingVendasSemanaController = PagingController(firstPageKey: 1);
  PagingController<int, VendaDto> pagingVendasTodasController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 3, vsync: this);

    hojeDataInicial = DateTime(hoje.year, hoje.month, hoje.day).toUtc();
    hojeDataFinal = DateTime(hoje.year, hoje.month, hoje.day, 23, 59, 59, 999, 999).toUtc();
    semanaDataInicial = hojeDataInicial.subtract(Duration(days: hoje.weekday - 1)).toUtc();
    semanaDataFinal = semanaDataInicial.add(const Duration(days: 6)).toUtc();
  }

  @override
  void dispose() {
    tabController.dispose();

    pagingVendasHojeController.dispose();
    pagingVendasSemanaController.dispose();
    pagingVendasTodasController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                setState(() {
                  isSearchVisibled = !isSearchVisibled;
                  if (!isSearchVisibled && !isNullorEmpty(compradorNomeFilter)) {
                    compradorNomeFilter = "";
                    searchController.clear();
                    switch (tabController.index) {
                      case 0:
                        pagingVendasHojeController.refresh();
                        break;
                      case 1:
                        pagingVendasSemanaController.refresh();
                        break;
                      case 2:
                        pagingVendasTodasController.refresh();
                        break;
                    }
                  }
                  if (isSearchVisibled) {
                    searchNode.requestFocus();
                  } else {
                    searchNode.unfocus();
                  }
                });
              },
              icon: const Icon(MdiIcons.magnify),
            )
          ],
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
          title: const Text("Vendas"),
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
                    controller: tabController,
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
                    if (debounce?.isActive ?? false) debounce!.cancel();
                    debounce = Timer(const Duration(milliseconds: 500), () {
                      setState(() {
                        compradorNomeFilter = value;
                        switch (tabController.index) {
                          case 0:
                            pagingVendasHojeController.refresh();
                            break;
                          case 1:
                            pagingVendasSemanaController.refresh();
                            break;
                          case 2:
                            pagingVendasTodasController.refresh();
                            break;
                        }
                      });
                    });
                  }),
                  style: Theme.of(context).primaryTextTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nome do comprador',
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
              child: TabBarView(
                controller: tabController,
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
          return await Modular.get<IVendasRepository>().getVendas(page, hojeDataInicial, hojeDataFinal, compradorNomeFilter);
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
            onTap: (() async {
              var refresh = await Modular.to.pushNamed<bool>('/vendas/details/${item.id.toString()}');
              if (refresh ?? false) pagingVendasHojeController.refresh();
            }),
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
          return await Modular.get<IVendasRepository>().getVendas(page, semanaDataInicial, semanaDataFinal, compradorNomeFilter);
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
              var refresh = await Modular.to.pushNamed<bool>('/vendas/details/${item.id.toString()}');
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
          return await Modular.get<IVendasRepository>().getVendas(page, null, null, compradorNomeFilter);
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
              var refresh = await Modular.to.pushNamed<bool>('/vendas/details/${item.id.toString()}');
              if (refresh ?? false) pagingVendasTodasController.refresh();
            },
            child: CardVenda(item: item),
          );
        },
      ),
    );
  }
}
