import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/carrinho/carrinho_page.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';

class ProdutosPage extends StatefulWidget {
  final String title;
  const ProdutosPage({Key? key, this.title = 'Produtos'}) : super(key: key);
  @override
  ProdutosPageState createState() => ProdutosPageState();
}

class ProdutosPageState extends State<ProdutosPage> {
  ProdutosPageState() : super();

  final List<Product> _productList = [
    Product(
        name: "Fresh Mutton",
        amount: "15.08",
        description: "Fresh meat, ready to eat",
        discount: "5",
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
        discount: "7",
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
        discount: "9",
        unitName: "kg",
        rating: "3",
        ratingCount: "65",
        imagePath: "assets/bakery.png",
        qty: 2),
    Product(
        name: "Fresh Mutton",
        amount: "15.08",
        description: "Fresh meat, ready to eat",
        discount: "6",
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
        discount: "8",
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
          title: const Text("Produtos"),
          actions: [
            IconButton(
                onPressed: () async {
                  //
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
                //
              },
            ),
            IconButton(
                onPressed: () {
                  //
                },
                icon: Modular.get<ThemeStore>().isDarkModeEnable ? Image.asset('assets/filter_white.png') : Image.asset('assets/filter_black.png')),
            IconButton(
              onPressed: () async {
                await Modular.to.pushNamed('/produtos/edit');
              },
              icon: const Icon(MdiIcons.plus),
            ),
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
                            padding: const EdgeInsets.only(top: 10, left: 130),
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
                                "Estoque alvo ${_productList[index].discount}",
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
                                "Estoque ${_productList[index].discount}",
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
