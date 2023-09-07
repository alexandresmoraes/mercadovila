import 'package:vilasesmo/app/modules/account/account_edit_controller.dart';
import 'package:vilasesmo/app/modules/produtos/produtos_edit_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/produtos/produtos_edit_page.dart';
import 'package:vilasesmo/app/modules/produtos/produtos_page.dart';
import 'package:vilasesmo/app/utils/repositories/produtos_repository.dart';

class ProdutosModule extends Module {
  static const routeName = '/produtos/';

  @override
  final List<Bind> binds = [
    Bind.factory((i) => ProdutosEditController()),
    Bind.factory((i) => AccountEditController()),
    BindInject((i) => ProdutosRepository(), isSingleton: true, isLazy: true),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/',
        child: (_, args) => const ProdutosPage(),
        transition: TransitionType.rightToLeft,
        duration: const Duration(milliseconds: 500)),
    ChildRoute('/edit/:id', child: (_, args) => ProdutosEditPage(id: args.params['id'])),
    ChildRoute('/new', child: (_, args) => const ProdutosEditPage()),
  ];
}
