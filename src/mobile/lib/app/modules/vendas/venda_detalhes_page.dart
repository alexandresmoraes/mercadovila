import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/carrinho/carrinho_page.dart';

class VendaDetalhesPage extends StatefulWidget {
  final String title;
  const VendaDetalhesPage({Key? key, this.title = 'OrderDetailPage'}) : super(key: key);
  @override
  VendaDetalhesPageState createState() => VendaDetalhesPageState();
}

class VendaDetalhesPageState extends State<VendaDetalhesPage> {
  VendaDetalhesPageState() : super();

  final List<Product> _productList = [
    Product(
        name: "Hersheys",
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
        name: "Pé de moça",
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
          title: const Text("#578192 - Compra"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
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
                                    '${_productList[0].name}',
                                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                                  ),
                                  Text(
                                    '${_productList[0].description}',
                                    style: Theme.of(context).primaryTextTheme.displayMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  RichText(
                                      text: TextSpan(text: "\$", style: Theme.of(context).primaryTextTheme.displayMedium, children: [
                                    TextSpan(
                                      text: '${_productList[0].amount}',
                                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                                    ),
                                    TextSpan(
                                      text: ' / ${_productList[0].unitName}',
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
                                            text: "${_productList[0].rating} ",
                                            style: Theme.of(context).primaryTextTheme.bodyLarge,
                                            children: [
                                              TextSpan(
                                                text: '|',
                                                style: Theme.of(context).primaryTextTheme.displayMedium,
                                              ),
                                              TextSpan(
                                                text: ' ${_productList[0].ratingCount} ratings',
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
                              _productList[0].discount != null
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
                                        "${_productList[0].discount} off",
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
                                  _productList[0].isFavourite = !_productList[0].isFavourite!;
                                  setState(() {});
                                },
                                icon: _productList[0].isFavourite! ? Image.asset('assets/fav_red.png') : Image.asset('assets/fav_grey.png'),
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
                                image: AssetImage('${_productList[0].imagePath}'),
                              ),
                            ),
                            height: 100,
                            width: 120,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
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
                                    '${_productList[1].name}',
                                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                                  ),
                                  Text(
                                    '${_productList[1].description}',
                                    style: Theme.of(context).primaryTextTheme.displayMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  RichText(
                                      text: TextSpan(text: "\$", style: Theme.of(context).primaryTextTheme.displayMedium, children: [
                                    TextSpan(
                                      text: '${_productList[1].amount}',
                                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                                    ),
                                    TextSpan(
                                      text: ' / ${_productList[1].unitName}',
                                      style: Theme.of(context).primaryTextTheme.displayMedium,
                                    )
                                  ])),
                                  // Paddingr
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Theme.of(context).primaryColorLight,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Theme.of(context).primaryColorLight,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Theme.of(context).primaryColorLight,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Theme.of(context).primaryColorLight,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Theme.of(context).iconTheme.color,
                                        ),
                                      ],
                                    ),
                                  ),
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
                              _productList[1].discount != null
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
                                        "${_productList[1].discount} off",
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
                                  _productList[1].isFavourite = !_productList[1].isFavourite!;
                                  setState(() {});
                                },
                                icon: _productList[1].isFavourite! ? Image.asset('assets/fav_red.png') : Image.asset('assets/fav_grey.png'),
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
                                image: AssetImage('${_productList[1].imagePath}'),
                              ),
                            ),
                            height: 100,
                            width: 120,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ListTile(
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  contentPadding: const EdgeInsets.all(0),
                  title: Text(
                    "Preço",
                    style: Theme.of(context).primaryTextTheme.headlineSmall,
                  ),
                ),
                ListTile(
                  minVerticalPadding: 0,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  minLeadingWidth: 30,
                  contentPadding: const EdgeInsets.all(0),
                  leading: Text(
                    "Total",
                    style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
                  ),
                  trailing: Text(
                    "\$61.27",
                    style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Status",
                      style: Theme.of(context).primaryTextTheme.labelSmall,
                    ),
                    const Expanded(child: SizedBox()),
                    const Icon(MdiIcons.checkCircle, size: 20, color: Colors.greenAccent),
                    Text(
                      "Entrega",
                      style: Theme.of(context).primaryTextTheme.labelSmall,
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
                    colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor],
                  ),
                ),
                margin: const EdgeInsets.all(8.0),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                    onPressed: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => CheckoutScreen(a: widget.analytics, o: widget.observer),
                      //   ),
                      // );
                    },
                    child: const Text(
                      'Cancelar',
                    )),
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
