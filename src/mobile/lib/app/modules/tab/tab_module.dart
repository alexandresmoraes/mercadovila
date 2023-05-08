import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/tab/tab_page.dart';

class TabModule extends Module {
  static const routeName = '/';

  @override
  final List<Bind> binds = [
    //Bind.lazySingleton((i) => HomeStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => const TabPage()),
  ];
}
