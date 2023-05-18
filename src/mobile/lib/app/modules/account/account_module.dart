import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/account/pages/accounts_page.dart';
import 'package:vilasesmo/app/modules/account/pages/venda_detalhes_page.dart';
import 'package:vilasesmo/app/modules/account/pages/vendas_page.dart';

import 'pages/account_edit_page.dart';

class AccountModule extends Module {
  static const routeName = '/account/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/accounts', child: (_, args) => const AccountsPage()),
    ChildRoute('/edit', child: (_, args) => const AccountEditPage()),
    ChildRoute('/vendas', child: (_, args) => const VendasPage()),
    ChildRoute('/venda-detalhes', child: (_, args) => const VendaDetalhesPage()),
  ];
}
