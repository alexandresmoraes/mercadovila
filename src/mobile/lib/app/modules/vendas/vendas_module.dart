import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/vendas/venda_detail_controller.dart';
import 'package:vilasesmo/app/modules/vendas/venda_detail_page.dart';
import 'package:vilasesmo/app/modules/vendas/vendas_page.dart';

class VendasModule extends Module {
  static const routeName = '/vendas/';

  @override
  final List<Bind> binds = [
    Bind.factory((i) => VendaDetailController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const VendasPage(), transition: TransitionType.rightToLeft, duration: const Duration(milliseconds: 500)),
    ChildRoute('/details/:id', child: (_, args) => VendaDetailPage(id: args.params['id'])),
  ];
}
