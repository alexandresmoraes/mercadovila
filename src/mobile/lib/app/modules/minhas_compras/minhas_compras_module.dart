import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/minhas_compras/minhas_compras_page.dart';

class MinhasComprasModule extends Module {
  static const routeName = '/minhas-compras/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const MinhasComprasPage(), transition: TransitionType.leftToRight, duration: const Duration(milliseconds: 500)),
  ];
}
