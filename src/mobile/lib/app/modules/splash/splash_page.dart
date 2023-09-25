import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vilasesmo/app/modules/carrinho/carrinho_store.dart';
import 'package:vilasesmo/app/modules/login/login_module.dart';
import 'package:vilasesmo/app/modules/tab/tab_module.dart';
import 'package:vilasesmo/app/stores/account_store.dart';
import 'package:vilasesmo/app/utils/services/interfaces/i_auth_service.dart';

class SplashPage extends StatefulWidget {
  final String title;
  const SplashPage({Key? key, this.title = 'Splash'}) : super(key: key);
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1)).then((value) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();

      var authService = Modular.get<IAuthService>();

      if (await authService.isAuthenticated()) {
        Modular.get<CarrinhoStore>().load();
        Modular.get<AccountStore>().setAccount(await authService.me());
        Modular.to.pushReplacementNamed(TabModule.routeName);
      } else {
        Modular.to.pushReplacementNamed(LoginModule.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor],
        ),
      ),
      child: Center(
          child: Image.asset(
        'assets/appicon_512x512.png',
        fit: BoxFit.cover,
      )),
    ));
  }
}
