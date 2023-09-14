import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/search/search_filter_store.dart';

class SearchFilterPage extends StatefulWidget {
  final String title;
  const SearchFilterPage({Key? key, this.title = 'Opções'}) : super(key: key);
  @override
  SearchFilterPageState createState() => SearchFilterPageState();
}

class SearchFilterPageState extends State<SearchFilterPage> {
  SearchFilterPageState() : super();

  SearchFilterStore searchFilterStore = Modular.get<SearchFilterStore>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Opções"),
          actions: [
            IconButton(
              onPressed: () {
                searchFilterStore.clean();
              },
              icon: const Icon(MdiIcons.syncIcon),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 10),
                    child: Text(
                      'Ordenar por nome',
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                Observer(builder: (_) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Radio(
                        value: ECatalogoTodosQueryOrder.nameAsc.index,
                        groupValue: searchFilterStore.selectOrder,
                        onChanged: (_) {
                          searchFilterStore.setSelectedOrder(ECatalogoTodosQueryOrder.nameAsc.index);
                        },
                      ),
                      Text(
                        "A a Z",
                        style: searchFilterStore.selectOrder == ECatalogoTodosQueryOrder.nameAsc.index
                            ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'PoppinsMedium',
                                  color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                                )
                            : Theme.of(context).primaryTextTheme.displayMedium,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Radio(
                            value: ECatalogoTodosQueryOrder.nameDesc.index,
                            groupValue: searchFilterStore.selectOrder,
                            onChanged: (_) {
                              searchFilterStore.setSelectedOrder(ECatalogoTodosQueryOrder.nameDesc.index);
                            }),
                      ),
                      Text(
                        "Z a A",
                        style: searchFilterStore.selectOrder == ECatalogoTodosQueryOrder.nameDesc.index
                            ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'PoppinsMedium',
                                  color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                                )
                            : Theme.of(context).primaryTextTheme.displayMedium,
                      ),
                    ],
                  );
                }),
                const Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      'Ordenar por preço',
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                Observer(builder: (_) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Radio(
                        value: ECatalogoTodosQueryOrder.priceLowToHigh.index,
                        groupValue: searchFilterStore.selectOrder,
                        onChanged: (dynamic val) {
                          searchFilterStore.setSelectedOrder(ECatalogoTodosQueryOrder.priceLowToHigh.index);
                        },
                      ),
                      Text(
                        "Menor p/ maior",
                        style: searchFilterStore.selectOrder == ECatalogoTodosQueryOrder.priceLowToHigh.index
                            ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'PoppinsMedium',
                                  color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                                )
                            : Theme.of(context).primaryTextTheme.displayMedium,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Radio(
                            value: ECatalogoTodosQueryOrder.priceHighToLow.index,
                            groupValue: searchFilterStore.selectOrder,
                            onChanged: (dynamic val) {
                              searchFilterStore.setSelectedOrder(ECatalogoTodosQueryOrder.priceHighToLow.index);
                            }),
                      ),
                      Text(
                        "Maior p/ menor",
                        style: searchFilterStore.selectOrder == ECatalogoTodosQueryOrder.priceHighToLow.index
                            ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'PoppinsMedium',
                                  color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                                )
                            : Theme.of(context).primaryTextTheme.displayMedium,
                      ),
                    ],
                  );
                }),
                const Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      'Filtrar por disponibilidade',
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                Observer(builder: (_) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                          value: searchFilterStore.inStock,
                          onChanged: (val) {
                            searchFilterStore.inStock = val!;
                          }),
                      Text(
                        "Em estoque",
                        style: searchFilterStore.inStock
                            ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'PoppinsMedium',
                                  color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                                )
                            : Theme.of(context).primaryTextTheme.displayMedium,
                      ),
                      Checkbox(
                          value: searchFilterStore.outOfStock,
                          onChanged: (val) {
                            searchFilterStore.outOfStock = val!;
                          }),
                      Text(
                        "Fora de estoque",
                        style: searchFilterStore.outOfStock
                            ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'PoppinsMedium',
                                  color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                                )
                            : Theme.of(context).primaryTextTheme.displayMedium,
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(
                        stops: const [0, .90],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor])),
                margin: const EdgeInsets.all(15.0),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  onPressed: () {
                    Modular.to.pop(true);
                  },
                  child: const Text('Aplicar'),
                ),
              ),
            ),
          ],
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
