import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/tab/home_page.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';

class VendasPage extends StatefulWidget {
  final String title;
  const VendasPage({Key? key, this.title = 'Vendas'}) : super(key: key);
  @override
  VendasPageState createState() => VendasPageState();
}

class Order {
  String? orderId;

  String? name;
  String? orderStatus;

  String? datetime;
  String? orderOption;
  String? amount;
  bool isProductsVisible = false;
  Order({this.amount, this.name, this.datetime, this.orderId, this.orderOption, this.orderStatus});
}

class VendasPageState extends State<VendasPage> {
  VendasPageState() : super();

  final List<Order> _orderListScreen = [
    Order(
        name: "Alexandre Moraes",
        amount: "15.08",
        datetime: "12:03 PM | 24.02.2021",
        orderId: "#51602",
        orderOption: "Detalhes",
        orderStatus: "Delivered"),
    Order(
        name: "Aurora Maria Moraes",
        amount: "11.08",
        datetime: "10:57 AM | 25.02.2021",
        orderId: "#202145",
        orderOption: "Detalhes",
        orderStatus: "Scheduled"),
    Order(
        name: "Angelina Moraes",
        amount: "12.08",
        datetime: "12:03 PM | 24.02.2021",
        orderId: "#202145",
        orderOption: "Detalhes",
        orderStatus: "Ongoing"),
    Order(
        name: "Sabrina Moraes",
        amount: "15.08",
        datetime: "11:36 AM | 27.02.2021",
        orderId: "#412563",
        orderOption: "Detalhes",
        orderStatus: "Cancelled"),
    Order(
        name: "Alice Moraes",
        amount: "11.08",
        datetime: "12:03 PM | 26.02.2021",
        orderId: "#202145",
        orderOption: "Detalhes",
        orderStatus: "Scheduled"),
    Order(
        name: "Angelo Moraes",
        amount: "12.08",
        datetime: "12:03 PM | 28.02.2021",
        orderId: "#412563",
        orderOption: "Detalhes",
        orderStatus: "Ongoing"),
    Order(
        name: "Maria Valentina Moraes",
        amount: "15.08",
        datetime: "12:03 PM | 24.02.2021",
        orderId: "#51602",
        orderOption: "Detalhes",
        orderStatus: "Delivered"),
    Order(
        name: "Alexandre Moraes",
        amount: "11.08",
        datetime: "10:57 AM | 25.02.2021",
        orderId: "#202145",
        orderOption: "Detalhes",
        orderStatus: "Scheduled"),
    Order(
        name: "Aurora Moraes",
        amount: "12.08",
        datetime: "12:03 PM | 24.02.2021",
        orderId: "#202145",
        orderOption: "Detalhes",
        orderStatus: "Ongoing"),
    Order(
        name: "Angelina Moraes",
        amount: "15.08",
        datetime: "11:36 AM | 27.02.2021",
        orderId: "#412563",
        orderOption: "Detalhesr",
        orderStatus: "Cancelled"),
    Order(
        name: "Luisa Moraes",
        amount: "11.08",
        datetime: "12:03 PM | 26.02.2021",
        orderId: "#202145",
        orderOption: "Detalhes",
        orderStatus: "Scheduled"),
    Order(
        name: "Ana Alice Moraes",
        amount: "12.08",
        datetime: "12:03 PM | 28.02.2021",
        orderId: "#412563",
        orderOption: "Detalhes",
        orderStatus: "Ongoing"),
  ];

  final List<Product> _allItemsList = [
    Product(
        name: "Cheetos Lua",
        amount: "4.89",
        description: "1 un",
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
        description: "2 un",
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
        description: "1 un",
        isFavourite: false,
        unitName: "un",
        rating: "3",
        ratingCount: "65",
        imagePath: "assets/wheat.png",
        qty: 2),
    Product(
        name: "Coca-Cola Lata",
        amount: "0.5",
        description: "2 un",
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
        description: "1 un",
        isFavourite: false,
        unitName: "kg",
        rating: "4.5",
        ratingCount: "12",
        imagePath: "assets/bakery.png",
        qty: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
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
                    backgroundColor:
                        Modular.get<ThemeStore>().isDarkModeEnable ? const Color(0xFF435276) : const Color(0xFFEDF2F6),
                    bottom: TabBar(
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 3.0,
                          color: Modular.get<ThemeStore>().isDarkModeEnable
                              ? Theme.of(context).primaryColor
                              : const Color(0xFFEF5656),
                        ),
                        insets: const EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      labelColor: Modular.get<ThemeStore>().isDarkModeEnable ? Colors.white : Colors.black,
                      indicatorWeight: 4,
                      unselectedLabelStyle: TextStyle(
                          fontSize: 13,
                          color: Modular.get<ThemeStore>().isDarkModeEnable ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400),
                      labelStyle: TextStyle(
                          fontSize: 13,
                          color: Modular.get<ThemeStore>().isDarkModeEnable ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Modular.get<ThemeStore>().isDarkModeEnable
                          ? Theme.of(context).primaryColor
                          : const Color(0xFFEF5656),
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
                    _allOrders(),
                    _allOrders(),
                    _allOrders(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _allItemsWidgetList() {
    List<Widget> widgetList = [];
    try {
      for (int i = 0; i < _allItemsList.length; i++) {
        widgetList.add(
          Container(
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
                            '${_allItemsList[i].name}',
                            style: Theme.of(context).primaryTextTheme.bodyLarge,
                          ),
                          Text(
                            '${_allItemsList[i].description}',
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
                                    style: TextStyle(
                                        fontSize: 10, color: Theme.of(context).primaryTextTheme.displayMedium!.color),
                                  ),
                                  Text(
                                    '${_allItemsList[i].amount}',
                                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                                  )
                                ],
                              ),
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
                          '${_allItemsList[i].imagePath}',
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
        );
      }
      return widgetList;
    } catch (e) {
      widgetList.add(const SizedBox());
      if (kDebugMode) {
        print("Exception - vendas_page.dart - _allCategoryWidgetList():$e");
      }
      return widgetList;
    }
  }

  Widget _allOrders() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: _orderListScreen.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Modular.to.pushNamed('/vendas/venda-detalhes');
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            color: Modular.get<ThemeStore>().isDarkModeEnable
                                ? const Color(0xFF373C58)
                                : const Color(0xFFF2F5F8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Text(
                            _orderListScreen[index].orderId!,
                            style: Theme.of(context).primaryTextTheme.displayMedium,
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Icon(
                          _orderListScreen[index].orderStatus == 'Cancelled'
                              ? MdiIcons.closeOctagon
                              : MdiIcons.checkDecagram,
                          size: 20,
                          color: _orderListScreen[index].orderStatus == 'Cancelled'
                              ? Colors.red
                              : _orderListScreen[index].orderStatus == 'Delivered'
                                  ? Colors.greenAccent
                                  : _orderListScreen[index].orderStatus == 'Ongoing'
                                      ? Colors.blue
                                      : Theme.of(context).primaryColorLight,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            _orderListScreen[index].orderStatus!,
                            style: Theme.of(context).primaryTextTheme.displayMedium,
                          ),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -3, horizontal: -4),
                    contentPadding: const EdgeInsets.all(0),
                    minLeadingWidth: 0,
                    leading: const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 21,
                        backgroundImage: AssetImage('assets/person.png'),
                      ),
                    ),
                    title: Text(
                      _orderListScreen[index].name!,
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      _orderListScreen[index].datetime!,
                      style: Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "\$${_orderListScreen[index].amount}",
                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _orderListScreen[index].isProductsVisible = !_orderListScreen[index].isProductsVisible;
                            });
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Color(0xFFF05656), borderRadius: BorderRadius.all(Radius.circular(6))),
                            margin: const EdgeInsets.only(right: 10, top: 5),
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            width: 60,
                            height: 23,
                            child: Center(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 0,
                                    ),
                                    child: Text(
                                      'Detalhes',
                                      style: Theme.of(context).primaryTextTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: _orderListScreen[index].isProductsVisible ? 180 : 0,
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: 180,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: _allItemsWidgetList(),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Modular.get<ThemeStore>().isDarkModeEnable
                        ? Theme.of(context).dividerTheme.color!.withOpacity(0.05)
                        : Theme.of(context).dividerTheme.color,
                  ),
                ],
              ),
            );
          }),
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
