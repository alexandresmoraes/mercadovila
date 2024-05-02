import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/modules/meus_pagamentos/meus_pagamentos_page.dart';
import 'package:mercadovila/app/modules/pagamentos/pagamentos_pagar_controller.dart';
import 'package:mercadovila/app/utils/guard/auth_guard.dart';

class MeusPagamentosModule extends Module {
  static const routeName = '/meus-pagamentos/';

  @override
  final List<Bind> binds = [
    Bind.factory((i) => PagamentosPagarController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const MeusPagamentosPage(),
        guards: [AuthGuard()],
        transition: TransitionType.rightToLeft,
        duration: const Duration(milliseconds: 500)),
  ];
}
