import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFedf2f6)],
        ),
      ),
      child: Center(
          child: Image.asset(
        'assets/appicon_512x512.png',
        fit: BoxFit.scaleDown,
      )),
    ));
  }
}
