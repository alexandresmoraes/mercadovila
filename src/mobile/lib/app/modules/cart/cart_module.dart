import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/cart/cart_page.dart';

class CartModule extends Module {
  static const routeName = '/cart/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const CartPage(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 500)),
  ];
}
