import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchFilterPage extends StatefulWidget {
  final String title;
  const SearchFilterPage({Key? key, this.title = 'CartFilterPage'}) : super(key: key);
  @override
  SearchFilterPageState createState() => SearchFilterPageState();
}

class SearchFilterPageState extends State<SearchFilterPage> {
  SearchFilterPageState() : super();
  int? _selectedName = 0;
  int? _selectedPrice = 7;
  bool? _inStock = true;
  bool? _inOutOfStock = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Opções"),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(MdiIcons.syncIcon)),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio(
                      value: 1,
                      groupValue: _selectedName,
                      onChanged: (dynamic val) {
                        _selectedName = val;
                        setState(() {});
                      },
                    ),
                    Text(
                      "A a Z",
                      style: _selectedName == 1
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
                          value: 2,
                          groupValue: _selectedName,
                          onChanged: (dynamic val) {
                            _selectedName = val;
                            setState(() {});
                          }),
                    ),
                    Text(
                      "Z a A",
                      style: _selectedName == 2
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                  ],
                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio(
                      value: 7,
                      groupValue: _selectedPrice,
                      onChanged: (dynamic val) {
                        _selectedPrice = val;
                        setState(() {});
                      },
                    ),
                    Text(
                      "Menor p/ maior",
                      style: _selectedPrice == 7
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
                          value: 8,
                          groupValue: _selectedPrice,
                          onChanged: (dynamic val) {
                            _selectedPrice = val;
                            setState(() {});
                          }),
                    ),
                    Text(
                      "Maior p/ menor",
                      style: _selectedPrice == 8
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                  ],
                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: _inStock,
                        onChanged: (val) {
                          _inStock = val;
                          setState(() {});
                        }),
                    Text(
                      "Em estoque",
                      style: _inStock!
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                    Checkbox(
                        value: _inOutOfStock,
                        onChanged: (val) {
                          _inOutOfStock = val;
                          setState(() {});
                        }),
                    Text(
                      "Fora de estoque",
                      style: _inOutOfStock!
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                  ],
                ),
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
                      Navigator.of(context).pop();
                    },
                    child: const Text('Aplicar (99 Total de itens)')),
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
