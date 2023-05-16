import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';

class AccountsPage extends StatefulWidget {
  final String title;
  const AccountsPage({Key? key, this.title = 'AccountsPage'}) : super(key: key);
  @override
  AccountsPageState createState() => AccountsPageState();
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

class AccountsPageState extends State<AccountsPage> {
  final List<Order> _orderListScreen = [
    Order(
        name: "Alexandre Moraes",
        amount: "15.08",
        datetime: "12:03 PM | 24.02.2021",
        orderId: "#51602",
        orderOption: "Re - order",
        orderStatus: "Delivered"),
    Order(
        name: "Angelina Moraes",
        amount: "11.08",
        datetime: "10:57 AM | 25.02.2021",
        orderId: "#202145",
        orderOption: "Cancel",
        orderStatus: "Scheduled"),
    Order(
        name: "Alice Moraes",
        amount: "12.08",
        datetime: "12:03 PM | 24.02.2021",
        orderId: "#202145",
        orderOption: "Track Order",
        orderStatus: "Ongoing"),
    Order(
        name: "Maria Valentina Moraes",
        amount: "15.08",
        datetime: "11:36 AM | 27.02.2021",
        orderId: "#412563",
        orderOption: "Re - order",
        orderStatus: "Cancelled"),
    Order(
        name: "Maria Clara Moraes",
        amount: "11.08",
        datetime: "12:03 PM | 26.02.2021",
        orderId: "#202145",
        orderOption: "Cancel",
        orderStatus: "Scheduled"),
    Order(
        name: "Aurora Maria Moraes",
        amount: "12.08",
        datetime: "12:03 PM | 28.02.2021",
        orderId: "#412563",
        orderOption: "Re - order",
        orderStatus: "Ongoing"),
    Order(
        name: "Angelo Moraes",
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
        name: "Alice Moraes",
        amount: "12.08",
        datetime: "12:03 PM | 24.02.2021",
        orderId: "#202145",
        orderOption: "Track Order",
        orderStatus: "Ongoing"),
    Order(
        name: "Fresh Mutton",
        amount: "15.08",
        datetime: "11:36 AM | 27.02.2021",
        orderId: "#412563",
        orderOption: "Re - order",
        orderStatus: "Cancelled"),
    Order(
        name: "Angelina Moraes",
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
                Navigator.of(context).pop();
              },
              child: const Align(
                alignment: Alignment.center,
                child: Icon(MdiIcons.arrowLeft),
              ),
            ),
            centerTitle: true,
            title: const Text(
              "Contas de usuários",
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: _allUsers(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _allUsers() {
    final ThemeStore _themeStore = Modular.get<ThemeStore>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: _orderListScreen.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // TODO
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => OrderDetailScreen(a: widget.analytics, o: widget.observer),
                //   ),
                // );
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
                            color: _themeStore.isDarkModeEnable ? const Color(0xFF373C58) : const Color(0xFFF2F5F8),
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
                  // Row(
                  //   children: const [
                  //     CircleAvatar(
                  //       radius: 31,
                  //       backgroundColor: Colors.white,
                  //       child: CircleAvatar(
                  //         radius: 28,
                  //         backgroundImage: AssetImage('assets/person.png'),
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
                    // trailing: Column(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     Text(
                    //       "\$${_orderListScreen[index].amount}",
                    //       style: Theme.of(context).primaryTextTheme.bodyLarge,
                    //     ),
                    //     Text(
                    //       "${_orderListScreen[index].orderOption}",
                    //       style: Theme.of(context).primaryTextTheme.displayMedium!.copyWith(color: Colors.red),
                    //     ),
                    //   ],
                    // ),
                  ),
                  Divider(
                    color:
                        _themeStore.isDarkModeEnable ? Theme.of(context).dividerTheme.color!.withOpacity(0.05) : Theme.of(context).dividerTheme.color,
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
