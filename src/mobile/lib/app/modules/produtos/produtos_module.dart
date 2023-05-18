import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/produtos/produtos_page.dart';

class ProdutosModule extends Module {
  static const routeName = '/products/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const ProdutosPage(), transition: TransitionType.rightToLeft, duration: const Duration(milliseconds: 500)),
  ];
}
