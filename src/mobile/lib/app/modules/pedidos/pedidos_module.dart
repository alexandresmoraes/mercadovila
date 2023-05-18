import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/pedidos/pedidos_page.dart';

class PedidosModule extends Module {
  static const routeName = '/pedidos/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const PedidosPage(), transition: TransitionType.leftToRight, duration: const Duration(milliseconds: 500)),
  ];
}
