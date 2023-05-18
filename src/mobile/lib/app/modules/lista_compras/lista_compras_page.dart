import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/carrinho/carrinho_page.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';

class ListaComprasPage extends StatefulWidget {
  final String title;
  const ListaComprasPage({Key? key, this.title = 'ListaComprasPage'}) : super(key: key);
  @override
  ListaComprasPageState createState() => ListaComprasPageState();
}

class ListaComprasPageState extends State<ListaComprasPage> {
  ListaComprasPageState() : super();

  final List<Product> _productList = [
    Product(
        name: "Fresh Mutton",
        amount: "15.08",
        description: "Fresh meat, ready to eat",
        discount: "20%",
        isFavourite: true,
        unitName: "kg",
        rating: "2",
        ratingCount: "102",
        imagePath: "assets/lamb.png",
        qty: 1),
    Product(
        name: "Fresh Chicken",
        amount: "11.08",
        description: "Fresh Chicken, ready to eat",
        discount: "20%",
        isFavourite: true,
        unitName: "kg",
        rating: "4.5",
        ratingCount: "12",
        imagePath: "assets/wheat.png",
        qty: 0),
    Product(
        name: "Fresh Lamb",
        amount: "12.08",
        description: "Fresh lamb, ready to eat",
        isFavourite: false,
        unitName: "kg",
        rating: "3",
        ratingCount: "65",
        imagePath: "assets/bakery.png",
        qty: 2),
    Product(
        name: "Fresh Mutton",
        amount: "15.08",
        description: "Fresh meat, ready to eat",
        discount: "20%",
        isFavourite: true,
        unitName: "kg",
        rating: "4.5",
        ratingCount: "98",
        imagePath: "assets/lamb.png",
        qty: 0),
    Product(
        name: "Fresh Chicken",
        amount: "11.08",
        description: "Fresh Chicken, ready to eat",
        discount: "20%",
        isFavourite: true,
        unitName: "kg",
        rating: "4.5",
        ratingCount: "98",
        imagePath: "assets/wheat.png",
        qty: 2),
    Product(
        name: "Fresh Lamb",
        amount: "12.08",
        description: "Fresh lamb, ready to eat",
        isFavourite: false,
        unitName: "kg",
        rating: "4.5",
        ratingCount: "12",
        imagePath: "assets/cheese.png",
        qty: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Align(
              alignment: Alignment.center,
              child: Icon(MdiIcons.arrowLeft),
            ),
          ),
          title: const Text("Lista de compras"),
          actions: [
            IconButton(
                onPressed: () async {
                  // await br.openBarcodeScanner();
                },
                icon: const Icon(MdiIcons.barcode)),
            FloatingActionButton(
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: badges.Badge(
                badgeContent: const Text(
                  "3",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                  ),
                ),
                padding: const EdgeInsets.all(6),
                badgeColor: Colors.red,
                child: Icon(
                  MdiIcons.shoppingOutline,
                  color: Theme.of(context).primaryIconTheme.color,
                ),
              ),
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => CheckoutScreen(a: widget.analytics, o: widget.observer),
                //   ),
                // );
              },
            ),
            IconButton(
                onPressed: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => FilterScreen(a: widget.analytics, o: widget.observer),
                  //   ),
                  // );
                },
                icon: Modular.get<ThemeStore>().isDarkModeEnable ? Image.asset('assets/filter_white.png') : Image.asset('assets/filter_black.png')),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: _productList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => ProductDetailScreen(a: widget.analytics, o: widget.observer),
                    //   ),
                    // );
                  },
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 110,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, left: 120),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_productList[index].name}',
                                  style: Theme.of(context).primaryTextTheme.bodyLarge,
                                ),
                                Text(
                                  '${_productList[index].description}',
                                  style: Theme.of(context).primaryTextTheme.displayMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                RichText(
                                    text: TextSpan(text: "\$", style: Theme.of(context).primaryTextTheme.displayMedium, children: [
                                  TextSpan(
                                    text: '${_productList[index].amount}',
                                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                                  ),
                                  TextSpan(
                                    text: ' / ${_productList[index].unitName}',
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
                                          text: "${_productList[index].rating} ",
                                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                                          children: [
                                            TextSpan(
                                              text: '|',
                                              style: Theme.of(context).primaryTextTheme.displayMedium,
                                            ),
                                            TextSpan(
                                              text: ' ${_productList[index].ratingCount} ratings',
                                              style: Theme.of(context).primaryTextTheme.displayLarge,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
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
                            _productList[index].discount != null
                                ? Container(
                                    height: 20,
                                    width: 60,
                                    decoration: const BoxDecoration(
                                      color: Colors.lightBlue,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "${_productList[index].discount} off",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).primaryTextTheme.bodySmall,
                                    ),
                                  )
                                : const SizedBox(
                                    height: 20,
                                    width: 60,
                                  ),
                            IconButton(
                              onPressed: () {
                                _productList[index].isFavourite = !_productList[index].isFavourite!;
                                setState(() {});
                              },
                              icon: _productList[index].isFavourite! ? Image.asset('assets/fav_red.png') : Image.asset('assets/fav_grey.png'),
                            )
                          ],
                        ),
                      ),
                      _productList[index].qty == null || (_productList[index].qty != null && _productList[index].qty == 0)
                          ? Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).iconTheme.color,
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                ),
                                child: IconButton(
                                  padding: const EdgeInsets.all(0),
                                  visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                                  onPressed: () {
                                    _productList[index].qty = _productList[index].qty! + 1;
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Theme.of(context).primaryTextTheme.bodySmall!.color,
                                  ),
                                ),
                              ),
                            )
                          : Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 28,
                                width: 80,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    stops: const [0, .90],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColorLight],
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        padding: const EdgeInsets.all(0),
                                        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                                        onPressed: () {
                                          _productList[index].qty = _productList[index].qty! - 1;
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          FontAwesomeIcons.minus,
                                          size: 11,
                                          color: Theme.of(context).primaryTextTheme.bodySmall!.color,
                                        )),
                                    Text(
                                      "${_productList[index].qty}",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyLarge!
                                          .copyWith(color: Theme.of(context).primaryTextTheme.bodySmall!.color),
                                    ),
                                    IconButton(
                                        padding: const EdgeInsets.all(0),
                                        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                                        onPressed: () {
                                          _productList[index].qty = _productList[index].qty! + 1;
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          FontAwesomeIcons.plus,
                                          size: 11,
                                          color: Theme.of(context).primaryTextTheme.bodySmall!.color,
                                        )),
                                  ],
                                ),
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
