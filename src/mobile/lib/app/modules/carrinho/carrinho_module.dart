import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/carrinho/carrinho_page.dart';

class CarrinhoModule extends Module {
  static const routeName = '/carrinho/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const CarrinhoPage(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 500)),
  ];
}
