import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/products/products_page.dart';

class ProductsModule extends Module {
  static const routeName = '/products/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const ProductsPage(), transition: TransitionType.rightToLeft, duration: const Duration(milliseconds: 500)),
  ];
}
