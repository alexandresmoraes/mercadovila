import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/modules/tab/tab_module.dart';

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
      Modular.to.pushReplacementNamed(TabModule.routeName);
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
