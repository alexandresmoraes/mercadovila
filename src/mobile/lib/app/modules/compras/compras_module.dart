import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/compras/compras_carrinho_page.dart';
import 'package:vilasesmo/app/modules/compras/compras_page.dart';
import 'package:vilasesmo/app/modules/compras/compras_scanner_page.dart';

class ComprasModule extends Module {
  static const routeName = '/compras/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const ComprasPage(), transition: TransitionType.rightToLeft, duration: const Duration(milliseconds: 500)),
    ChildRoute('/carrinho', child: (_, args) => const CopmprasCarrinhoPage()),
    ChildRoute('/scanner', child: (_, args) => const ComprasScannerPage()),
  ];
}
