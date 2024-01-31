import 'package:vilasesmo/app/modules/pagamentos/pagamentos_pagar_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/pagamentos/pagamentos_pagar_page.dart';
import 'package:vilasesmo/app/modules/pagamentos/pagamentos_page.dart';

class PagamentosModule extends Module {
  static const routeName = '/pagamentos/';

  @override
  final List<Bind> binds = [
    Bind.factory((i) => PagamentosPagarController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const PagamentosPage(), transition: TransitionType.rightToLeft, duration: const Duration(milliseconds: 500)),
    ChildRoute('/pagar', child: (_, args) => const PagamentosPagarPage()),
  ];
}
