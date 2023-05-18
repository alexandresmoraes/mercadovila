import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';

class OrdersPage extends StatefulWidget {
  final String title;
  const OrdersPage({Key? key, this.title = 'OrdersPage'}) : super(key: key);
  @override
  OrdersPageState createState() => OrdersPageState();
}

class Order {
  String? orderId;

  String? name;
  String? orderStatus;

  String? datetime;
  String? orderOption;
  String? amount;
  Order({this.amount, this.name, this.datetime, this.orderId, this.orderOption, this.orderStatus});
}

class OrdersPageState extends State<OrdersPage> {
  OrdersPageState() : super();
  final List<Order> _orderListScreen = [
    Order(
        name: "Alexandre Moraes",
        amount: "15.08",
        datetime: "12:03 PM | 24.02.2021",
        orderId: "#51602",
        orderOption: "Re - order",
        orderStatus: "Delivered"),
    Order(
        name: "Aurora Maria Moraes",
        amount: "11.08",
        datetime: "10:57 AM | 25.02.2021",
        orderId: "#202145",
        orderOption: "Cancel",
        orderStatus: "Scheduled"),
    Order(
        name: "Angelina Moraes",
        amount: "12.08",
        datetime: "12:03 PM | 24.02.2021",
        orderId: "#202145",
        orderOption: "Track Order",
        orderStatus: "Ongoing"),
    Order(
        name: "Sabrina Moraes",
        amount: "15.08",
        datetime: "11:36 AM | 27.02.2021",
        orderId: "#412563",
        orderOption: "Re - order",
        orderStatus: "Cancelled"),
    Order(
        name: "Alice Moraes",
        amount: "11.08",
        datetime: "12:03 PM | 26.02.2021",
        orderId: "#202145",
        orderOption: "Cancel",
        orderStatus: "Scheduled"),
    Order(
        name: "Angelo Moraes",
        amount: "12.08",
        datetime: "12:03 PM | 28.02.2021",
        orderId: "#412563",
        orderOption: "Re - order",
        orderStatus: "Ongoing"),
    Order(
        name: "Maria Valentina Moraes",
        amount: "15.08",
        datetime: "12:03 PM | 24.02.2021",
        orderId: "#51602",
        orderOption: "Re - order",
        orderStatus: "Delivered"),
    Order(
        name: "Alexandre Moraes",
        amount: "11.08",
        datetime: "10:57 AM | 25.02.2021",
        orderId: "#202145",
        orderOption: "Cancel",
        orderStatus: "Scheduled"),
    Order(
        name: "Aurora Moraes",
        amount: "12.08",
        datetime: "12:03 PM | 24.02.2021",
        orderId: "#202145",
        orderOption: "Track Order",
        orderStatus: "Ongoing"),
    Order(
        name: "Angelina Moraes",
        amount: "15.08",
        datetime: "11:36 AM | 27.02.2021",
        orderId: "#412563",
        orderOption: "Re - order",
        orderStatus: "Cancelled"),
    Order(
        name: "Luisa Moraes",
        amount: "11.08",
        datetime: "12:03 PM | 26.02.2021",
        orderId: "#202145",
        orderOption: "Cancel",
        orderStatus: "Scheduled"),
    Order(
        name: "Ana Alice Moraes",
        amount: "12.08",
        datetime: "12:03 PM | 28.02.2021",
        orderId: "#412563",
        orderOption: "Re - order",
        orderStatus: "Ongoing"),
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
                    backgroundColor: Modular.get<ThemeStore>().isDarkModeEnable ? const Color(0xFF435276) : const Color(0xFFEDF2F6),
                    bottom: TabBar(
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

  Widget _allOrders() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: _orderListScreen.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Modular.to.pushNamed('/account/order-details');
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
                            color: Modular.get<ThemeStore>().isDarkModeEnable ? const Color(0xFF373C58) : const Color(0xFFF2F5F8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Text(
                            _orderListScreen[index].orderId!,
                            style: Theme.of(context).primaryTextTheme.displayMedium,
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Icon(
                          _orderListScreen[index].orderStatus == 'Cancelled' ? MdiIcons.closeOctagon : MdiIcons.checkDecagram,
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
                        Text(
                          "${_orderListScreen[index].orderOption}",
                          style: Theme.of(context).primaryTextTheme.displayMedium!.copyWith(color: Colors.red),
                        ),
                      ],
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
