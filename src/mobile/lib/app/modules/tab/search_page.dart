import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/carrinho/carrinho_page.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/services/auth_service.dart';

class SearchPage extends StatefulWidget {
  final String title;
  const SearchPage({Key? key, this.title = 'SearchPage'}) : super(key: key);
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final List<Product> _allCategoryList = [
    Product(
        name: "Basmati Rice",
        amount: "7.01",
        description: "120+ items",
        discount: "20%",
        isFavourite: true,
        unitName: "kg",
        rating: "2",
        ratingCount: "102",
        imagePath: "assets/wheat.png",
        qty: 1),
    Product(
        name: "Chicken",
        amount: "11.0",
        description: "120+ items",
        discount: "20%",
        isFavourite: true,
        unitName: "kg",
        rating: "4.5",
        ratingCount: "12",
        imagePath: "assets/cheese.png",
        qty: 0),
    Product(
        name: "Fresh meat",
        amount: "9.25",
        description: "120+ items",
        isFavourite: false,
        unitName: "kg",
        rating: "3",
        ratingCount: "65",
        imagePath: "assets/lamb.png",
        qty: 2),
    Product(
        name: "Fresh Mutton",
        amount: "0.5",
        description: "120+ items",
        discount: "20%",
        isFavourite: true,
        unitName: "kg",
        rating: "4.5",
        ratingCount: "98",
        imagePath: "assets/bakery.png",
        qty: 0),
    Product(
        name: "Fresh Lamb",
        amount: "6.5",
        description: "120+ items",
        isFavourite: false,
        unitName: "kg",
        rating: "4.5",
        ratingCount: "12",
        imagePath: "assets/wheat.png",
        qty: 3),
    Product(
        name: "Basmati Rice",
        amount: "7.01",
        description: "120+ items",
        discount: "20%",
        isFavourite: true,
        unitName: "kg",
        rating: "2",
        ratingCount: "102",
        imagePath: "assets/cheese.png",
        qty: 1),
    Product(
        name: "Chicken",
        amount: "1.0",
        description: "120+ items",
        discount: "20%",
        isFavourite: true,
        unitName: "kg",
        rating: "4.5",
        ratingCount: "12",
        imagePath: "assets/lamb.png",
        qty: 0),
    Product(
        name: "Fresh meat",
        amount: "9.25",
        description: "120+ items",
        isFavourite: false,
        unitName: "kg",
        rating: "3",
        ratingCount: "65",
        imagePath: "assets/cheese.png",
        qty: 2),
    Product(
        name: "Fresh Mutton",
        amount: "0.5",
        description: "120+ items",
        discount: "20%",
        isFavourite: true,
        unitName: "kg",
        rating: "4.5",
        ratingCount: "98",
        imagePath: "assets/cheese.png",
        qty: 0),
    Product(
        name: "Fresh Lamb",
        amount: "6.5",
        description: "120+ items",
        isFavourite: false,
        unitName: "kg",
        rating: "4.5",
        ratingCount: "12",
        imagePath: "assets/wheat.png",
        qty: 3),
    Product(
        name: "Basmati Rice",
        amount: "7.01",
        description: "120+ items",
        discount: "20%",
        isFavourite: true,
        unitName: "kg",
        rating: "2",
        ratingCount: "102",
        imagePath: "assets/wheat.png",
        qty: 1),
    Product(
        name: "Chicken",
        amount: "11.0",
        description: "120+ items",
        discount: "20%",
        isFavourite: true,
        unitName: "kg",
        rating: "4.5",
        ratingCount: "12",
        imagePath: "assets/bakery.png",
        qty: 0),
  ];

  SearchPageState() : super();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Todos"),
            actions: [
              IconButton(
                  onPressed: () {
                    Modular.to.pushNamed('/search/search-filter');
                  },
                  icon: Modular.get<ThemeStore>().isDarkModeEnable ? Image.asset('assets/filter_white.png') : Image.asset('assets/filter_black.png')),
            ],
          ),
          body: _productListWidget()),
    );
  }

  _productListWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 4, right: 4, top: 10),
        child: Wrap(spacing: 0, runSpacing: 10, children: _productList()),
      ),
    );
  }

  List<Widget> _productList() {
    List<Widget> productList = [];

    for (int i = 0; i < _allCategoryList.length; i++) {
      productList.add(
        Container(
          height: 160,
          margin: const EdgeInsets.only(top: 30, left: 4, right: 4),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: 170,
                width: (MediaQuery.of(context).size.width / 3) - 11,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 78, left: 7, right: 7),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_allCategoryList[i].name}',
                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                        ),
                        Text(
                          '${_allCategoryList[i].description}',
                          style: Theme.of(context).primaryTextTheme.displayMedium,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                                text: TextSpan(text: "From \$", style: Theme.of(context).primaryTextTheme.displayMedium, children: [
                              TextSpan(
                                text: '${_allCategoryList[i].amount}',
                                style: Theme.of(context).primaryTextTheme.bodyLarge,
                              ),
                            ])),
                            InkWell(
                                customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                onTap: () {
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => ProductListScreen(a: widget.analytics, o: widget.observer),
                                  //   ),
                                  // );

                                  Modular.get<AuthService>().me();
                                },
                                child: Image.asset('assets/orange_next.png')),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: -30,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('${_allCategoryList[i].imagePath}'),
                    ),
                  ),
                  height: 90,
                  width: 110,
                ),
              )
            ],
          ),
        ),
      );
    }
    return productList;
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
