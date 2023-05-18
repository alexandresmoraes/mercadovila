import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';

class CartPage extends StatefulWidget {
  final String title;
  const CartPage({Key? key, this.title = 'CartPage'}) : super(key: key);
  @override
  CartPageState createState() => CartPageState();
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

class Address {
  String? title;
  String? address;
  Address({this.title, this.address});
}

class CartPageState extends State<CartPage> {
  GlobalKey<ScaffoldState>? _scaffoldKey;

  String? selectedCouponCode;
  int? vendorId;
  String selectedTimeSlot = '';
  String? barberName;
  int _currentIndex = 0;
  int? selectedCoupon;
  PageController? _pageController;
  ScrollController? _scrollController;
  int? _selectedPaymentOption = 3;
  DateTime? selectedDate;
  bool step1Done = false;
  bool step2Done = false;
  TextEditingController textController1 = TextEditingController();
  TextEditingController textController2 = TextEditingController();
  List<Address> addressList = [
    Address(title: "Home", address: "Dn 53 Madison Building, Roy Enclave, lane 02 Nearest Landmark - Water park New York, USA"),
    Address(title: "Office", address: "STP 02 Building sector 05, Module 02, Nearest landmark- New york , USA"),
    Address(title: "Home 02", address: "STP 02 Building sector 05, Module 02, Nearest landmark- New york , USA"),
  ];
  CartPageState() : super();
  @override
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController(initialScrollOffset: _currentIndex.toDouble());
    _pageController = PageController(initialPage: _currentIndex);
    _pageController!.addListener(() {});
  }

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
        qty: 3),
  ];
  @override
  Widget build(BuildContext context) {
    List<String> orderProcess = ['Carrinho', 'Pagamento'];
    List<String> orderProcessText = ['Carrinho', 'Pagamento'];

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              orderProcessText[_currentIndex],
            ),
            leading: IconButton(
                onPressed: () {
                  if (_currentIndex == 0) {
                    Modular.to.pop();
                  } else {
                    _pageController!.animateToPage(_currentIndex - 1, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
                    if (_currentIndex == 0) {
                      step1Done = false;
                    } else if (_currentIndex == 1) {
                      step2Done = false;
                    }

                    setState(() {});
                  }
                },
                icon: const Icon(MdiIcons.arrowLeft)),
            automaticallyImplyLeading: _currentIndex == 0 ? true : false,
          ),
          body: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 20,
                margin: const EdgeInsets.only(left: 8, right: 8, bottom: 0, top: 10),
                child: Center(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: orderProcess.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int i) {
                        return Modular.get<ThemeStore>().isDarkModeEnable
                            ? Row(
                                children: [
                                  Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color: _currentIndex >= i ? Colors.black : const Color(0xFF505266),
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1.5,
                                            ),
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.only(left: 25, right: 10),
                                          child: Text(
                                            orderProcess[i],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          )),
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: _currentIndex >= i ? Colors.white : Colors.black,
                                          border: Border.all(color: _currentIndex == i ? Colors.black : const Color(0xFF505266), width: 1.5),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.circle,
                                          size: 8,
                                          color: _currentIndex >= i ? Colors.black : const Color(0xFF505266),
                                        ),
                                      ),
                                    ],
                                  ),
                                  i == 1
                                      ? const SizedBox()
                                      : Container(
                                          height: 2,
                                          color: _currentIndex >= i ? Colors.black : const Color(0xFF505266),
                                          width: 20,
                                          margin: const EdgeInsets.all(0),
                                        ),
                                ],
                              )
                            : Row(
                                children: [
                                  Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color: _currentIndex >= i ? const Color(0xFF4A4352) : const Color(0xFFBcc8d2),
                                            border: Border.all(
                                              color: _currentIndex >= i ? const Color(0xFF4A4352) : const Color(0xFFBcc8d2),
                                              width: 1.5,
                                            ),
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.only(left: 25, right: 10),
                                          child: Text(
                                            orderProcess[i],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          )),
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: _currentIndex >= i ? const Color(0xFF4A4352) : const Color(0xFFBcc8d2), width: 1.5),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.circle,
                                          size: 8,
                                          color: _currentIndex >= i ? const Color(0xFF4A4352) : const Color(0xFFBcc8d2),
                                        ),
                                      ),
                                    ],
                                  ),
                                  i == 3
                                      ? const SizedBox()
                                      : Container(
                                          height: 2,
                                          color: _currentIndex >= i ? const Color(0xFF4A4352) : const Color(0xFFBcc8d2),
                                          width: 20,
                                          margin: const EdgeInsets.all(0),
                                        ),
                                ],
                              );
                      }),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    _currentIndex = index;
                    double currentIndex = _currentIndex.toDouble();
                    _scrollController!.animateTo(currentIndex, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
                    setState(() {});
                  },
                  children: [
                    _cartWidget(),
                    _payment(),
                  ],
                ),
              ),
            ],
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
                        if (_currentIndex == 3) {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => OrderSuccessScreen(a: widget.analytics, o: widget.observer),
                          //   ),
                          // );
                        } else {
                          _pageController!.animateToPage(_currentIndex + 1, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
                        }
                      },
                      child: Text(
                        _currentIndex == 0
                            ? 'Checkout'
                            : _currentIndex == 1
                                ? 'Select Time'
                                : _currentIndex == 2
                                    ? 'Proced pay'
                                    : 'Pagamento',
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cartWidget() {
    return SingleChildScrollView(
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
                              onPressed: () {},
                              icon: Icon(
                                FontAwesomeIcons.minus,
                                size: 11,
                                color: Theme.of(context).primaryTextTheme.bodySmall!.color,
                              )),
                          Text(
                            "${_productList[0].qty}",
                            style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryTextTheme.bodySmall!.color),
                          ),
                          IconButton(
                              padding: const EdgeInsets.all(0),
                              visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                              onPressed: () {},
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
                                      text: "${_productList[1].rating} ",
                                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                                      children: [
                                        TextSpan(
                                          text: '|',
                                          style: Theme.of(context).primaryTextTheme.displayMedium,
                                        ),
                                        TextSpan(
                                          text: ' ${_productList[1].ratingCount} ratings',
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
                              onPressed: () {},
                              icon: Icon(
                                FontAwesomeIcons.minus,
                                size: 11,
                                color: Theme.of(context).primaryTextTheme.bodySmall!.color,
                              )),
                          Text(
                            "${_productList[1].qty}",
                            style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryTextTheme.bodySmall!.color),
                          ),
                          IconButton(
                              padding: const EdgeInsets.all(0),
                              visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                              onPressed: () {},
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Todal",
                style: Theme.of(context).primaryTextTheme.labelSmall,
              ),
              Text(
                "\$80.62",
                style: Theme.of(context).primaryTextTheme.labelSmall,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Desconto",
                  style: Theme.of(context).primaryTextTheme.labelSmall,
                ),
                Text(
                  " - \$20.02",
                  style: Theme.of(context).primaryTextTheme.displayMedium!.copyWith(color: Colors.blue),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Cupom",
                  style: Theme.of(context).primaryTextTheme.labelSmall,
                ),
                Text(
                  "Aplicar Cupom",
                  style: Theme.of(context).primaryTextTheme.labelSmall!.copyWith(color: Theme.of(context).primaryColorLight),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Entrega",
                      style: Theme.of(context).primaryTextTheme.labelSmall,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Icon(
                        Icons.error_outline,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
                Text(
                  " - \$20.02",
                  style: Theme.of(context).primaryTextTheme.labelSmall!.copyWith(color: Colors.blue),
                )
              ],
            ),
          ),
          const Divider(),
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
          Modular.get<ThemeStore>().isDarkModeEnable
              ? Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/checkout_cart_dark.png',
                      ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                )
              : Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/checkout_cart_light.png',
                      ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                )
        ],
      ),
    ));
  }

  Widget _payment() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 7,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Offer discount',
                  style: Theme.of(context).primaryTextTheme.headlineSmall,
                ),
              ),
            ),
            ListTile(
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              minLeadingWidth: 30,
              contentPadding: const EdgeInsets.all(0),
              leading: Icon(
                MdiIcons.brightnessPercent,
                size: 20,
                color: Theme.of(context).primaryColorLight,
              ),
              title: Text(
                "Offer desc",
                style: Theme.of(context).primaryTextTheme.labelSmall,
              ),
              subtitle: InkWell(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => OfferListScreen(a: widget.analytics, o: widget.observer),
                  //   ),
                  // );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    "show offers",
                    style: Theme.of(context).primaryTextTheme.displayLarge,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 7,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Payment options',
                  style: Theme.of(context).primaryTextTheme.headlineSmall,
                ),
              ),
            ),
            RadioListTile(
                contentPadding: EdgeInsets.zero,
                value: 3,
                groupValue: _selectedPaymentOption,
                onChanged: (dynamic val) {
                  _selectedPaymentOption = val;
                  setState(() {});
                },
                title: Text(
                  "HDFC Credit Card",
                  style: Theme.of(context).primaryTextTheme.bodyLarge,
                ),
                subtitle: Text(
                  "•••• •••• •••• 5229",
                  style: Theme.of(context).primaryTextTheme.displayMedium,
                ),
                secondary: Image.asset('assets/master_card.png')),
            RadioListTile(
                contentPadding: EdgeInsets.zero,
                value: 4,
                groupValue: _selectedPaymentOption,
                onChanged: (dynamic val) {
                  _selectedPaymentOption = val;
                  setState(() {});
                },
                title: Text(
                  "ICICI Credit Card",
                  style: Theme.of(context).primaryTextTheme.bodyLarge,
                ),
                subtitle: Text(
                  "•••• •••• •••• 4421",
                  style: Theme.of(context).primaryTextTheme.displayMedium,
                ),
                secondary: Modular.get<ThemeStore>().isDarkModeEnable
                    ? Image.asset('assets/visa_card_dark.png')
                    : Image.asset('assets/visa_card_light.png')),
            InkWell(
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => AddPaymentScreen(a: widget.analytics, o: widget.observer),
                //   ),
                // );
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                    decoration: BoxDecoration(
                      color: Modular.get<ThemeStore>().isDarkModeEnable ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      "Payment options",
                      style: TextStyle(
                          fontSize: 14,
                          color: Modular.get<ThemeStore>().isDarkModeEnable ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Delivery",
                    style: Theme.of(context).primaryTextTheme.labelSmall,
                  ),
                  Text(
                    "26.03.2021, 12 - 4PM",
                    style: Theme.of(context).primaryTextTheme.labelSmall,
                  ),
                ],
              ),
            ),
            ListTile(
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                "Details",
                style: Theme.of(context).primaryTextTheme.headlineSmall,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Total",
                  style: Theme.of(context).primaryTextTheme.labelSmall,
                ),
                Text(
                  "\$80.62",
                  style: Theme.of(context).primaryTextTheme.labelSmall,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Preço",
                    style: Theme.of(context).primaryTextTheme.labelSmall,
                  ),
                  Text(
                    " - \$20.02",
                    style: Theme.of(context).primaryTextTheme.displayMedium!.copyWith(color: Colors.blue),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Desconto",
                    style: Theme.of(context).primaryTextTheme.labelSmall,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      "Cupom",
                      style: Theme.of(context).primaryTextTheme.labelSmall!.copyWith(color: Theme.of(context).primaryColorLight),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Charges",
                        style: Theme.of(context).primaryTextTheme.labelSmall,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Icon(
                          Icons.error_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                  Text(
                    " - \$20.02",
                    style: Theme.of(context).primaryTextTheme.labelSmall!.copyWith(color: Colors.blue),
                  )
                ],
              ),
            ),
            const Divider(),
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
          ],
        ),
      ),
    );
  }
}
