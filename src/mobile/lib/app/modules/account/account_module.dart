import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/account/accounts_page.dart';
import 'package:vilasesmo/app/modules/vendas/vendas_page.dart';

import 'account_edit_page.dart';

class AccountModule extends Module {
  static const routeName = '/account/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const VendasPage()),
    ChildRoute('/accounts', child: (_, args) => const AccountsPage()),
    ChildRoute('/edit', child: (_, args) => const AccountEditPage()),
  ];
}
