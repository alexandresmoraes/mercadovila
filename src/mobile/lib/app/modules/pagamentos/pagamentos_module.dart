import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/pagamentos/pagamentos_page.dart';

class PagamentosModule extends Module {
  static const routeName = '/pagamentos/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const PagamentosPage(), transition: TransitionType.leftToRight, duration: const Duration(milliseconds: 500)),
  ];
}
