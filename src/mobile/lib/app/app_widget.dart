import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/stores/theme_store.dart';
import 'package:mercadovila/app/theme/native_theme.dart';

class AppWidget extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setNavigatorKey(navigatorKey);
    return Observer(
      builder: (context) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Mercado Maluco',
        theme: nativeTheme(isDarkModeEnable: Modular.get<ThemeStore>().isDarkModeEnable),
        routerDelegate: Modular.routerDelegate,
        routeInformationParser: Modular.routeInformationParser,
      ),
    );
  }
}
