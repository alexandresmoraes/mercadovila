import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/modules/tab/tab_page.dart';

class TabModule extends Module {
  static const routeName = '/tab/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => const TabPage()),
  ];
}
