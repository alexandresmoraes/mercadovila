import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/theme/native_theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'VilaSESMO',
      theme: nativeTheme(isDarkModeEnable: true),
      routerDelegate: Modular.routerDelegate,
      routeInformationParser: Modular.routeInformationParser,
    );
  }
}
