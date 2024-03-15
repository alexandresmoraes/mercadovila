import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/compras/carrinho_page.dart';
import 'package:vilasesmo/app/modules/compras/compras_page.dart';
import 'package:vilasesmo/app/utils/repositories/produtos_repository.dart';

class ComprasModule extends Module {
  static const routeName = '/compras/';

  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ProdutosRepository()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const ComprasPage(), transition: TransitionType.rightToLeft, duration: const Duration(milliseconds: 500)),
    ChildRoute('/carrinho', child: (_, args) => const CarrinhoPage()),
  ];
}
