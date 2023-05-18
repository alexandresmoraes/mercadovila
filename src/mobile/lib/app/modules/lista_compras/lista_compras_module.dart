import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/lista_compras/lista_compras_page.dart';

class ListaComprasModule extends Module {
  static const routeName = '/lista-compras/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const ListaComprasPage(), transition: TransitionType.rightToLeft, duration: const Duration(milliseconds: 500)),
  ];
}
