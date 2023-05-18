import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/favoritos/favoritos_page.dart';

class FavoritosModule extends Module {
  static const routeName = '/favoritos/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const FavoritosPage(), transition: TransitionType.rightToLeft, duration: const Duration(milliseconds: 500)),
  ];
}
