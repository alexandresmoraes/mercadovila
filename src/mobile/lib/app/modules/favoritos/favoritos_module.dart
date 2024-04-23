import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/modules/favoritos/favoritos_page.dart';
import 'package:mercadovila/app/utils/guard/auth_guard.dart';

class FavoritosModule extends Module {
  static const routeName = '/favoritos/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const FavoritosPage(),
        guards: [AuthGuard()],
        transition: TransitionType.rightToLeft,
        duration: const Duration(milliseconds: 500)),
  ];
}
