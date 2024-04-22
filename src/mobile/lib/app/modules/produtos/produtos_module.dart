import 'package:mercadovila/app/modules/produtos/produto_scanner_page.dart';
import 'package:mercadovila/app/modules/produtos/produtos_detail_controller.dart';
import 'package:mercadovila/app/modules/produtos/produtos_detail_page.dart';
import 'package:mercadovila/app/modules/produtos/produtos_edit_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/modules/produtos/produtos_edit_page.dart';
import 'package:mercadovila/app/modules/produtos/produtos_page.dart';
import 'package:mercadovila/app/utils/repositories/produtos_repository.dart';

class ProdutosModule extends Module {
  static const routeName = '/produtos/';

  @override
  final List<Bind> binds = [
    Bind.factory((i) => ProdutosEditController()),
    Bind.factory((i) => ProdutosDetailController()),
    Bind.lazySingleton((i) => ProdutosRepository()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const ProdutosPage(), transition: TransitionType.rightToLeft, duration: const Duration(milliseconds: 500)),
    ChildRoute('/edit/:id', child: (_, args) => ProdutosEditPage(id: args.params['id'])),
    ChildRoute('/new', child: (_, args) => const ProdutosEditPage()),
    ChildRoute('/details/:id', child: (_, args) => ProdutosDetailPage(id: args.params['id'])),
    ChildRoute('/scanner', child: (_, args) => const ScannerPageProduto()),
  ];
}
