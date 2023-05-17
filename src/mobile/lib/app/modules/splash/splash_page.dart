import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/tab/tab_module.dart';
import 'package:vilasesmo/app/utility/services/interfaces/i_auth_service.dart';

class SplashPage extends StatefulWidget {
  final String title;
  const SplashPage({Key? key, this.title = 'SplashPage'}) : super(key: key);
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
        Modular.to.pushReplacementNamed(TabModule.routeName);
      } else {
        Modular.to.pushReplacementNamed(TabModule.routeName);
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
