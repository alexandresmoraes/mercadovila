import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/modules/carrinho/carrinho_page.dart';
import 'package:mercadovila/app/modules/carrinho/carrinho_success_page.dart';
import 'package:mercadovila/app/modules/tab/scanner_page.dart';

class CarrinhoModule extends Module {
  static const routeName = '/carrinho/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const CarrinhoPage(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 500)),
    ChildRoute('/scanner', child: (_, args) => const ScannerPage()),
    ChildRoute('/success',
        child: (_, args) => const CarrinhoSuccessPage(), transition: TransitionType.rotate, duration: const Duration(milliseconds: 700)),
  ];
}
