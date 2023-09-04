import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/compras/pedidos_page.dart';

class ComprasModule extends Module {
  static const routeName = '/pedidos/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const ComprasPage(), transition: TransitionType.rightToLeft, duration: const Duration(milliseconds: 500)),
  ];
}
