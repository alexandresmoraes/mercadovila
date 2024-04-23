import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/modules/carrinho/carrinho_page.dart';
import 'package:mercadovila/app/modules/carrinho/carrinho_success_page.dart';
import 'package:mercadovila/app/modules/tab/scanner_page.dart';
import 'package:mercadovila/app/utils/guard/auth_guard.dart';

class CarrinhoModule extends Module {
  static const routeName = '/carrinho/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const CarrinhoPage(),
        guards: [AuthGuard()],
        transition: TransitionType.fadeIn,
        duration: const Duration(milliseconds: 500)),
    ChildRoute('/scanner', child: (_, args) => const ScannerPage(), guards: [AuthGuard()]),
    ChildRoute('/success',
        child: (_, args) => const CarrinhoSuccessPage(),
        guards: [AuthGuard()],
        transition: TransitionType.rotate,
        duration: const Duration(milliseconds: 700)),
  ];
}
