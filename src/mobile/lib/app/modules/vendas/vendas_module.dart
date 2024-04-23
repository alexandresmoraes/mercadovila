import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/modules/vendas/venda_detail_controller.dart';
import 'package:mercadovila/app/modules/vendas/venda_detail_page.dart';
import 'package:mercadovila/app/modules/vendas/vendas_page.dart';
import 'package:mercadovila/app/utils/guard/auth_guard.dart';

class VendasModule extends Module {
  static const routeName = '/vendas/';

  @override
  final List<Bind> binds = [
    Bind.factory((i) => VendaDetailController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const VendasPage(),
        guards: [AuthGuard()],
        transition: TransitionType.rightToLeft,
        duration: const Duration(milliseconds: 500)),
    ChildRoute('/details/:id', child: (_, args) => VendaDetailPage(id: args.params['id']), guards: [AuthGuard()]),
  ];
}
