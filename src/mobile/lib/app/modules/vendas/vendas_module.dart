import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/vendas/venda_detalhes_page.dart';
import 'package:vilasesmo/app/modules/vendas/vendas_page.dart';

class VendasModule extends Module {
  static const routeName = '/vendas/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => const VendasPage()),
    ChildRoute('/venda-detalhes', child: (_, args) => const VendaDetalhesPage()),
  ];
}
