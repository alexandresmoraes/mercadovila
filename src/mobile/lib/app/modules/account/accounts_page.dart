import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/dtos/account_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_account_repository.dart';
import 'package:vilasesmo/app/utils/widgets/infinite_list.dart';

class AccountsPage extends StatefulWidget {
  final String title;
  const AccountsPage({Key? key, this.title = 'Contas de usuários'}) : super(key: key);
  @override
  AccountsPageState createState() => AccountsPageState();
}

class Order {
  String? orderId;

  String? name;
  String? orderStatus;

  String? email;
  String? orderOption;
  String? amount;
  Order({this.amount, this.name, this.email, this.orderId, this.orderOption, this.orderStatus});
}

class AccountsPageState extends State<AccountsPage> {
  bool isSearchVisibled = false;

  final List<Order> _orderListScreen = [
    Order(
      name: "Alexandre Moraes",
      amount: "15.08",
      email: "alexandresmoraes@me.com",
      orderId: "701b6b1f-e600-4553-826d-445bb99ecba8",
      orderOption: "Re - order",
      orderStatus: "Inativo",
    ),
    Order(
      name: "Angelina Moraes",
      amount: "11.08",
      email: "alexandresmoraes@me.com",
      orderId: "b1888d24-c6e9-49f4-8a93-ae8be90b3471",
      orderOption: "Cancel",
      orderStatus: "Ativo",
    ),
    Order(
      name: "Alice Moraes",
      amount: "12.08",
      email: "alexandresmoraes@me.com",
      orderId: "0d15726d-997a-4006-9914-2cf40b45c20d",
      orderOption: "Track Order",
      orderStatus: "Ativo",
    ),
    Order(
        name: "Maria Valentina Moraes",
        amount: "15.08",
        email: "alexandresmoraes@me.com",
        orderId: "23332f0b-353d-4fba-9a78-339a3f7c595f",
        orderOption: "Re - order",
        orderStatus: "Inativo"),
    Order(
        name: "Maria Clara Moraes",
        amount: "11.08",
        email: "alexandresmoraes@me.com",
        orderId: "6c0385b5-2222-4457-b9fd-bf1a17268309",
        orderOption: "Cancel",
        orderStatus: "Ativo"),
    Order(
        name: "Aurora Maria Moraes",
        amount: "12.08",
        email: "alexandresmoraes@me.com",
        orderId: "2dbc4d80-1059-41c0-a113-7dbfffe60547",
        orderOption: "Re - order",
        orderStatus: "Ativo"),
    Order(
        name: "Angelo Moraes",
        amount: "15.08",
        email: "alexandresmoraes@me.com",
        orderId: "5f0a8ca0-3f12-4691-bc3d-2a29457ec9a9",
        orderOption: "Re - order",
        orderStatus: "Ativo"),
    Order(
        name: "Alexandre Moraes",
        amount: "11.08",
        email: "alexandresmoraes@me.com",
        orderId: "9edc5278-17f5-4fb9-97ba-e04a4dc95dce",
        orderOption: "Cancel",
        orderStatus: "Ativo"),
    Order(
        name: "Alice Moraes",
        amount: "12.08",
        email: "alexandresmoraes@me.com",
        orderId: "76e90fc7-f3ce-45f5-91d0-7cebc74b205f",
        orderOption: "Track Order",
        orderStatus: "Ativo"),
    Order(
        name: "Fresh Mutton",
        amount: "15.08",
        email: "alexandresmoraes@me.com",
        orderId: "24918423-ee25-488e-b09a-ea3f731bb825",
        orderOption: "Re - order",
        orderStatus: "Inativo"),
    Order(
        name: "Angelina Moraes",
        amount: "11.08",
        email: "alexandresmoraes@me.com",
        orderId: "656d1814-8cc2-435d-8b38-becbefc7dc93",
        orderOption: "Cancel",
        orderStatus: "Ativo"),
    Order(
        name: "Angelo Moraes",
        amount: "12.08",
        email: "alexandresmoraes@me.com",
        orderId: "93f04dac-ce75-46a9-b0ec-30a68e5724ae",
        orderOption: "Re - order",
        orderStatus: "Ativo"),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Contas de usuários",
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  setState(() {
                    isSearchVisibled = !isSearchVisibled;
                  });
                },
                icon: const Icon(MdiIcons.magnify),
              ),
              IconButton(
                onPressed: () async {
                  await Modular.to.pushNamed('/account/new');
                  setState(() {});
                },
                icon: const Icon(MdiIcons.plus),
              ),
            ],
          ),
          body: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: isSearchVisibled ? 70 : 0,
                child: Container(
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(),
                  child: TextFormField(
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'Buscar por nome de usuários ou email',
                      prefixIcon: Icon(
                        MdiIcons.magnify,
                        size: isSearchVisibled ? 20 : 0,
                      ),
                      contentPadding: const EdgeInsets.only(top: 10),
                    ),
                  ),
                ),
              ),
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
    final ThemeStore themeStore = Modular.get<ThemeStore>();

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InfiniteList<AccountDto>(
          request: (page) async {
            return await Modular.get<IAccountRepository>().getAccounts(page, null);
          },
          cast: AccountDto.fromJson,
          emptyBuilder: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const ImageAsset('assets/images/img_no_upcoming.png', width: 160, height: 160),
                const SizedBox(height: 60),
                Text(
                  'Você não possui nenhum resultado.',
                  style: Theme.of(context).primaryTextTheme.displayLarge,
                ),
              ],
            ),
          ),
          itemBuilder: (context, item, index) {
            return InkWell(
              onTap: () {
                Modular.to.pushNamed('/account/edit/${item.id}');
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
                            color: themeStore.isDarkModeEnable ? const Color(0xFF373C58) : const Color(0xFFF2F5F8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Text(
                            item.id,
                            style: Theme.of(context).primaryTextTheme.displayMedium,
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Icon(
                            _orderListScreen[index].orderStatus == 'Inativo'
                                ? MdiIcons.closeOctagon
                                : MdiIcons.checkDecagram,
                            size: 20,
                            color: _orderListScreen[index].orderStatus == 'Inativo'
                                ? Colors.red
                                : index.floor().isEven
                                    ? Colors.greenAccent
                                    : Colors.blue),
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
                      item.username,
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      item.email,
                      style: Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "R\$ ${_orderListScreen[index].amount}",
                          style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: themeStore.isDarkModeEnable
                        ? Theme.of(context).dividerTheme.color!.withOpacity(0.05)
                        : Theme.of(context).dividerTheme.color,
                  ),
                ],
              ),
            );
          },
        ));
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
