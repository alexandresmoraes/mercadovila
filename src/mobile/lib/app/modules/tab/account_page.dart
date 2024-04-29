import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mercadovila/app/stores/account_store.dart';
import 'package:mercadovila/app/stores/theme_store.dart';
import 'package:mercadovila/app/utils/services/interfaces/i_auth_service.dart';
import 'package:mercadovila/app/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AccountPage extends StatefulWidget {
  final String title;
  const AccountPage({Key? key, this.title = 'Configurações'}) : super(key: key);
  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  PackageInfo? packageInfo;
  final AccountStore accountStore = Modular.get<AccountStore>();

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

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
                  child: Center(
                    child: Observer(builder: (_) {
                      if (!isNullorEmpty(accountStore.account!.fotoUrl)) {
                        return CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: 60,
                            child: SpinKitThreeBounce(
                              size: 30,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                          errorWidget: (context, url, error) => const CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 57,
                              backgroundImage: AssetImage('assets/person.png'),
                            ),
                          ),
                          imageUrl: '${Modular.get<BaseOptions>().baseUrl}/api/account/photo/${accountStore.account!.fotoUrl}',
                          imageBuilder: (context, imageProvider) {
                            return CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 57,
                                backgroundImage: imageProvider,
                              ),
                            );
                          },
                        );
                      }
                      return const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 57,
                          backgroundImage: AssetImage('assets/person.png'),
                        ),
                      );
                    }),
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
                !accountStore.account!.isAdmin
                    ? const SizedBox.shrink()
                    : ListTile(
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
                !accountStore.account!.isAdmin
                    ? const SizedBox.shrink()
                    : ListTile(
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
                !accountStore.account!.isAdmin
                    ? const SizedBox.shrink()
                    : ListTile(
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
                !accountStore.account!.isAdmin
                    ? const SizedBox.shrink()
                    : ListTile(
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
                !accountStore.account!.isAdmin
                    ? const SizedBox.shrink()
                    : ListTile(
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
                    Modular.to.pushNamed('/meus-pagamentos/');
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.cash,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                    size: 20,
                  ),
                  title: Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Text(
                      "Meus pagamentos",
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                !accountStore.account!.isAdmin
                    ? const SizedBox.shrink()
                    : ListTile(
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
                    Modular.to.pushNamed('/notificacoes/');
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
                  onChanged: (val) => Modular.get<ThemeStore>().setDarkMode(!Modular.get<ThemeStore>().isDarkModeEnable),
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
                  onTap: () {
                    showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: const Text('Atenção!'),
                        content: const Text('Tem certeza de que deseja sair?'),
                        actions: <CupertinoDialogAction>[
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () async {
                              Modular.to.pop();
                              Modular.get<IAuthService>().logout();
                            },
                            child: const Text(
                              'Sim',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            onPressed: () {
                              Modular.to.pop();
                            },
                            child: const Text('Não'),
                          ),
                        ],
                      ),
                    );
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
                  height: 20,
                ),
                ListTile(
                  onTap: () {},
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: Center(
                    child: Text(
                      "v${packageInfo?.version}",
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ))
      ],
    ));
  }
}
