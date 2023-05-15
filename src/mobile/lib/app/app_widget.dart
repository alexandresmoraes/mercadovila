import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/theme/native_theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'VilaSESMO',
        theme: nativeTheme(isDarkModeEnable: Modular.get<ThemeStore>().isDarkModeEnable),
        routerDelegate: Modular.routerDelegate,
        routeInformationParser: Modular.routeInformationParser,
      ),
    );
  }
}
