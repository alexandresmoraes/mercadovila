import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/stores/account_store.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';

class AccountPage extends StatefulWidget {
  final String title;
  const AccountPage({Key? key, this.title = 'Configurações'}) : super(key: key);
  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: 240,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(45),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor],
            ),
          ),
          alignment: Alignment.topCenter,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 240,
                alignment: Alignment.topCenter,
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/myprofile.png'),
                    ),
                  ),
                  alignment: Alignment.topCenter,
                  child: const Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 53,
                        backgroundImage: AssetImage('assets/person.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 45,
                child: Text(
                  Modular.get<AccountStore>().account!.nome,
                  style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 25,
                child: Text(
                  "${Modular.get<AccountStore>().account!.telefone} | ${Modular.get<AccountStore>().account!.email}",
                  style: Theme.of(context).primaryTextTheme.displayMedium!.copyWith(color: Colors.white),
                ),
              ),
              Positioned(
                bottom: -20,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(40),
                  ),
                  onTap: () {
                    Modular.to.pushNamed('/account/edit/${Modular.get<AccountStore>().account!.id!}');
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40),
                      ),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Image.asset('assets/edit.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Modular.to.pushNamed('/account/accounts');
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.accountBoxMultipleOutline,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                    size: 20,
                  ),
                  title: Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Text(
                      "Contas de usuários",
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Modular.to.pushNamed('/produtos/');
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.orderAlphabeticalAscending,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                    size: 20,
                  ),
                  title: Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Text(
                      "Produtos",
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Modular.to.pushNamed('/vendas/');
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.cartArrowUp,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                    size: 20,
                  ),
                  title: Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Text(
                      "Vendas",
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Modular.to.pushNamed('/compras/');
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.cartArrowDown,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                    size: 20,
                  ),
                  title: Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Text(
                      "Compras",
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Modular.to.pushNamed('/lista-compras/');
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.listBoxOutline,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                    size: 20,
                  ),
                  title: Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Text(
                      "Lista de compras",
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Modular.to.pushNamed('/minhas-compras/');
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.shoppingOutline,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                    size: 20,
                  ),
                  title: Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Text(
                      "Minhas compras",
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Modular.to.pushNamed('/pagamentos/');
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.walletOutline,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                    size: 20,
                  ),
                  title: Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Text(
                      "Pagamentos",
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Modular.to.pushNamed('/favoritos/');
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.heartOutline,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                    size: 20,
                  ),
                  title: Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Text(
                      "Favoritos",
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Modular.to.pushNamed('/notifications/');
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.bellOutline,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                    size: 20,
                  ),
                  title: Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Text(
                      "Notificações",
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  value: Modular.get<ThemeStore>().isDarkModeEnable,
                  onChanged: (val) =>
                      Modular.get<ThemeStore>().setDarkMode(!Modular.get<ThemeStore>().isDarkModeEnable),
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  secondary: !Modular.get<ThemeStore>().isDarkModeEnable
                      ? Icon(
                          Icons.dark_mode_outlined,
                          color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                          size: 20,
                        )
                      : Icon(
                          Icons.light_mode,
                          color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                          size: 20,
                        ),
                  title: Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Text(
                      Modular.get<ThemeStore>().isDarkModeEnable ? "Light" : "Dark",
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                ListTile(
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.textBox,
                    size: 20,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                  ),
                  title: Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Text(
                      "Sobre nós",
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Modular.to.pushNamed('/login/');
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.logout,
                    size: 20,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                  ),
                  title: Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Text(
                      "Sair",
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 70,
                )
              ],
            ),
          ),
        ))
      ],
    ));
  }
}
