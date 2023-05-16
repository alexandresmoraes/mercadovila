import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = 'HomePage'}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

class Product {
  String? name;
  int? qty;
  bool? isFavourite = false;
  String? rating;
  String? amount;
  String? unitName;
  String? ratingCount;
  String? description;
  String? discount;
  String? imagePath;
  Product(
      {this.amount,
      this.description,
      this.discount,
      this.isFavourite,
      this.name,
      this.qty,
      this.rating,
      this.ratingCount,
      this.unitName,
      this.imagePath});
}

class HomePageState extends State<HomePage> {
  CarouselController? _carouselController;
  final List<String> _imagesList = ['assets/homescreen_banner.png', 'assets/Banner0.png', 'assets/Banner1.png'];
  int _currentIndex = 0;
  final List<Product> _allCategoryList = [
    Product(
        name: "Cheetos Lua",
        amount: "4.89",
        description: "3 disponíveis",
        discount: "20%",
        isFavourite: true,
        unitName: "un",
        rating: "4.5",
        ratingCount: "102",
        imagePath: "assets/bakery.png",
        qty: 1),
    Product(
        name: "Hershey's",
        amount: "11.00",
        description: "1 disponível",
        discount: "20%",
        isFavourite: true,
        unitName: "un",
        rating: "4.5",
        ratingCount: "12",
        imagePath: "assets/lamb.png",
        qty: 0),
    Product(
        name: "Pé de Moça",
        amount: "9.25",
        description: "10 disponíveis",
        isFavourite: false,
        unitName: "un",
        rating: "3",
        ratingCount: "65",
        imagePath: "assets/wheat.png",
        qty: 2),
    Product(
        name: "Coca-Cola Lata",
        amount: "0.5",
        description: "6 disponíveis",
        discount: "20%",
        isFavourite: true,
        unitName: "un",
        rating: "4.5",
        ratingCount: "98",
        imagePath: "assets/cheese.png",
        qty: 0),
    Product(
        name: "Chettos Lua",
        amount: "6.5",
        description: "120 disponíveis",
        isFavourite: false,
        unitName: "kg",
        rating: "4.5",
        ratingCount: "12",
        imagePath: "assets/bakery.png",
        qty: 3),
  ];

  final List<Product> _topSellingProduct = [
    Product(
        name: "Cheetos Lua",
        amount: "4.89",
        description: "3 disponíveis",
        discount: "20%",
        isFavourite: true,
        unitName: "un",
        rating: "4.5",
        ratingCount: "102",
        imagePath: "assets/bakery.png",
        qty: 1),
    Product(
        name: "Coca-Cola Lata",
        amount: "11.0",
        description: "3 disponíveis",
        discount: "20%",
        isFavourite: true,
        unitName: "Packet",
        rating: "4.50",
        ratingCount: "12",
        imagePath: "assets/cheese.png",
        qty: 0),
    Product(
        name: "Hershey's",
        amount: "11.00",
        description: "1 disponível",
        discount: "20%",
        isFavourite: true,
        unitName: "un",
        rating: "4.5",
        ratingCount: "12",
        imagePath: "assets/lamb.png",
        qty: 0),
    Product(
        name: "Chettos Lua",
        amount: "6.5",
        description: "120 disponíveis",
        isFavourite: false,
        unitName: "kg",
        rating: "4.5",
        ratingCount: "12",
        imagePath: "assets/bakery.png",
        qty: 3),
    Product(
        name: "Pé de Moça",
        amount: "9.25",
        description: "10 disponíveis",
        isFavourite: false,
        unitName: "un",
        rating: "3",
        ratingCount: "65",
        imagePath: "assets/wheat.png",
        qty: 2),
  ];

  final List<Product> _spotLightProduct = [
    Product(
        name: "Hershey's",
        amount: "11.00",
        description: "1 disponível",
        discount: "20%",
        isFavourite: true,
        unitName: "un",
        rating: "4.5",
        ratingCount: "12",
        imagePath: "assets/lamb.png",
        qty: 0),
    Product(
        name: "Coca-Cola Lata",
        amount: "11.0",
        description: "3 disponíveis",
        discount: "20%",
        isFavourite: true,
        unitName: "Packet",
        rating: "4.50",
        ratingCount: "12",
        imagePath: "assets/cheese.png",
        qty: 0),
    Product(
        name: "Chettos Lua",
        amount: "6.5",
        description: "120 disponíveis",
        isFavourite: false,
        unitName: "kg",
        rating: "4.5",
        ratingCount: "12",
        imagePath: "assets/bakery.png",
        qty: 3),
    Product(
        name: "Pé de Moça",
        amount: "9.25",
        description: "10 disponíveis",
        isFavourite: false,
        unitName: "un",
        rating: "3",
        ratingCount: "65",
        imagePath: "assets/wheat.png",
        qty: 2),
    Product(
        name: "Hershey's",
        amount: "11.00",
        description: "1 disponível",
        discount: "20%",
        isFavourite: true,
        unitName: "un",
        rating: "4.5",
        ratingCount: "12",
        imagePath: "assets/lamb.png",
        qty: 0),
  ];
  List<Widget> _items() {
    List<Widget> list = [];
    for (int i = 0; i < _imagesList.length; i++) {
      list.add(Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(
                _imagesList[i],
              ),
            )),
      ));
    }
    return list;
  }

  HomePageState() : super();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => DeliveryLocationScreen(a: widget.analytics, o: widget.observer),
                  //   ),
                  // );
                },
                horizontalTitleGap: 2,
                contentPadding: const EdgeInsets.all(0),
                leading: Modular.get<ThemeStore>().isDarkModeEnable
                    ? Image.asset(
                        'assets/google_dark.png',
                        height: 60,
                        width: 30,
                      )
                    : Image.asset(
                        'assets/google_light.png',
                        height: 60,
                        width: 30,
                      ),
                title: Text('Bom dia', style: Theme.of(context).primaryTextTheme.bodyLarge),
                subtitle: Text('@alexandre',
                    style: Theme.of(context).primaryTextTheme.displayMedium!.copyWith(fontWeight: FontWeight.w300, fontFamily: 'PoppinsLight')),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => NotificationScreen(a: widget.analytics, o: widget.observer),
                          //   ),
                          // );
                        },
                        icon: Modular.get<ThemeStore>().isDarkModeEnable
                            ? Image.asset('assets/notificationIcon_white.png')
                            : Image.asset('assets/notificationIcon_black.png')),
                    Container(
                      decoration: const BoxDecoration(color: Color(0xFFF05656), borderRadius: BorderRadius.all(Radius.circular(6))),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      width: 84,
                      height: 30,
                      child: Row(
                        children: [
                          const Icon(
                            MdiIcons.currencyBrl,
                            color: Colors.white,
                            size: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 5,
                            ),
                            child: Text(
                              ' 15,59',
                              style: Theme.of(context).primaryTextTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
                child: CarouselSlider(
                    items: _items(),
                    carouselController: _carouselController,
                    options: CarouselOptions(
                        viewportFraction: 0.99,
                        initialPage: _currentIndex,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, _) {
                          _currentIndex = index;
                          setState(() {});
                        })),
              ),
              DotsIndicator(
                dotsCount: _imagesList.length,
                position: _currentIndex.toDouble(),
                onTap: (i) {
                  _currentIndex = i.toInt();
                  _carouselController!.animateToPage(_currentIndex, duration: const Duration(microseconds: 1), curve: Curves.easeInOut);
                },
                decorator: DotsDecorator(
                  activeSize: const Size(6, 6),
                  size: const Size(6, 6),
                  activeShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                  ),
                  activeColor: Theme.of(context).primaryColor,
                  color: Modular.get<ThemeStore>().isDarkModeEnable ? Colors.white : Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Todos',
                      style: Theme.of(context).primaryTextTheme.headlineSmall,
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => CategoryListScreen(a: widget.analytics, o: widget.observer),
                        //   ),
                        // );
                      },
                      child: Text(
                        'abrir',
                        style: Theme.of(context).primaryTextTheme.displayLarge,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: _allCategoryWidgetList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mais vendidos',
                      style: Theme.of(context).primaryTextTheme.headlineSmall,
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => ProductListScreen(a: widget.analytics, o: widget.observer),
                        //   ),
                        // );
                      },
                      child: Text(
                        'todos',
                        style: Theme.of(context).primaryTextTheme.displayLarge,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 210,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: _topSellingWidgetList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Favoritos',
                      style: Theme.of(context).primaryTextTheme.headlineSmall,
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => ProductListScreen(a: widget.analytics, o: widget.observer),
                        //   ),
                        // );
                      },
                      child: Text(
                        'todos',
                        style: Theme.of(context).primaryTextTheme.displayLarge,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 135,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: _spotLightWidgetList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Últimos vendidos',
                      style: Theme.of(context).primaryTextTheme.headlineSmall,
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => ProductListScreen(a: widget.analytics, o: widget.observer),
                        //   ),
                        // );
                      },
                      child: Text(
                        'todos',
                        style: Theme.of(context).primaryTextTheme.displayLarge,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 210,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: _topSellingWidgetList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Novos",
                      style: Theme.of(context).primaryTextTheme.headlineSmall,
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => ProductListScreen(a: widget.analytics, o: widget.observer),
                        //   ),
                        // );
                      },
                      child: Text(
                        'todos',
                        style: Theme.of(context).primaryTextTheme.displayLarge,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 210,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: _topSellingWidgetList(),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  List<Widget> _topSellingWidgetList() {
    List<Widget> widgetList = [];
    try {
      for (int i = 0; i < _topSellingProduct.length; i++) {
        widgetList.add(
          InkWell(
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => ProductDetailScreen(a: widget.analytics, o: widget.observer),
              //   ),
              // );
            },
            child: Container(
              height: 210,
              margin: const EdgeInsets.only(top: 10, left: 10),
              child: Stack(
                children: [
                  SizedBox(
                    height: 160,
                    width: 140,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: i % 3 == 1
                            ? const LinearGradient(
                                stops: [0, .90],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0XFF9EEEFF), Color(0XFFC0F4FF)],
                              )
                            : i % 3 == 2
                                ? const LinearGradient(
                                    stops: [0, .90],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Color(0XFFFFF1C0), Color(0XFFFFF1C0)],
                                  )
                                : const LinearGradient(
                                    stops: [0, .90],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Color(0XFFFFD4D7), Color(0XFFFFD4D7)],
                                  ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(17),
                          bottomLeft: Radius.circular(17),
                          bottomRight: Radius.circular(17),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 27, left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${_topSellingProduct[i].name}',
                              style: Theme.of(context).primaryTextTheme.titleMedium,
                            ),
                            Text(
                              '${_topSellingProduct[i].description}',
                              style: Theme.of(context).primaryTextTheme.titleSmall,
                            ),
                            Container(
                              width: 130,
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "R\$",
                                        style: Theme.of(context).primaryTextTheme.titleSmall,
                                      ),
                                      Text(
                                        '${_topSellingProduct[i].amount} ',
                                        style: Theme.of(context).primaryTextTheme.titleMedium,
                                      ),
                                      Text(
                                        '/ ${_topSellingProduct[i].unitName}',
                                        style: Theme.of(context).primaryTextTheme.titleSmall,
                                      )
                                    ],
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
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Modular.get<ThemeStore>().isDarkModeEnable
                            ? Theme.of(context).scaffoldBackgroundColor
                            : i % 3 == 1
                                ? const Color(0XFF9EEEFF)
                                : i % 3 == 2
                                    ? const Color(0XFFFFF1C0)
                                    : const Color(0XFFFFD4D7),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('${_topSellingProduct[i].imagePath}'),
                      )),
                      height: 120,
                      width: 130,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
      return widgetList;
    } catch (e) {
      widgetList.add(const SizedBox());
      if (kDebugMode) {
        print("Exception - homeScreen.dart - _topSellingWidgetList():$e");
      }
      return widgetList;
    }
  }

  List<Widget> _allCategoryWidgetList() {
    List<Widget> widgetList = [];
    try {
      for (int i = 0; i < _allCategoryList.length; i++) {
        widgetList.add(
          InkWell(
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => ProductDetailScreen(a: widget.analytics, o: widget.observer),
              //   ),
              // );
            },
            child: Container(
              height: 172,
              margin: const EdgeInsets.only(top: 40, left: 10),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    height: 172,
                    width: 145,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 78, left: 10, right: 10),
                        child: Column(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      ' ',
                                      style: Theme.of(context).primaryTextTheme.displayMedium,
                                    ),
                                    Text(
                                      'R\$ ',
                                      style: TextStyle(fontSize: 10, color: Theme.of(context).primaryTextTheme.displayMedium!.color),
                                    ),
                                    Text(
                                      '${_allCategoryList[i].amount}',
                                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                                    )
                                  ],
                                ),
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
                    top: -40,
                    left: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            '${_allCategoryList[i].imagePath}',
                          ),
                        ),
                      ),
                      height: 120,
                      width: 130,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
      return widgetList;
    } catch (e) {
      widgetList.add(const SizedBox());
      if (kDebugMode) {
        print("Exception - homeScreen.dart - _allCategoryWidgetList():$e");
      }
      return widgetList;
    }
  }

  List<Widget> _spotLightWidgetList() {
    List<Widget> widgetList = [];
    try {
      for (int i = 0; i < _spotLightProduct.length; i++) {
        widgetList.add(
          InkWell(
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => ProductDetailScreen(a: widget.analytics, o: widget.observer),
              //   ),
              // );
            },
            child: Container(
              margin: const EdgeInsets.only(top: 10, left: 10),
              child: Stack(
                children: [
                  SizedBox(
                    height: 105,
                    width: 180,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(17),
                          bottomLeft: Radius.circular(17),
                          bottomRight: Radius.circular(17),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 28, left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${_spotLightProduct[i].name}',
                              style: Theme.of(context).primaryTextTheme.bodyLarge,
                            ),
                            Container(
                              width: 130,
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "R\$",
                                        style: Theme.of(context).primaryTextTheme.displayMedium,
                                      ),
                                      Text(
                                        '${_spotLightProduct[i].amount} ',
                                        style: Theme.of(context).primaryTextTheme.headlineSmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${_spotLightProduct[i].description}',
                              style: Theme.of(context).primaryTextTheme.displayMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      height: 20,
                      width: 60,
                      decoration: const BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        "${_spotLightProduct[i].discount} off",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).primaryTextTheme.bodySmall,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    left: null,
                    top: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('${_spotLightProduct[i].imagePath}'),
                        ),
                      ),
                      height: 100,
                      width: 98,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return widgetList;
    } catch (e) {
      widgetList.add(const SizedBox());
      if (kDebugMode) {
        print("Exception - homeScreen.dart - _spotLightWidgetList():$e");
      }
      return widgetList;
    }
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
