import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/modules/minhas_compras/minhas_compras_page.dart';
import 'package:mercadovila/app/modules/vendas/venda_detail_controller.dart';
import 'package:mercadovila/app/modules/vendas/venda_detail_page.dart';

class MinhasComprasModule extends Module {
  static const routeName = '/minhas-compras/';

  @override
  final List<Bind> binds = [
    Bind.factory((i) => VendaDetailController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const MinhasComprasPage(), transition: TransitionType.rightToLeft, duration: const Duration(milliseconds: 500)),
    ChildRoute('/details/:id', child: (_, args) => VendaDetailPage(id: args.params['id'], isMinhaCompra: true)),
  ];
}
