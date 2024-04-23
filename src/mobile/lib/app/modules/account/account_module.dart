import 'package:mercadovila/app/modules/account/account_edit_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/modules/account/accounts_page.dart';
import 'package:mercadovila/app/modules/vendas/vendas_page.dart';
import 'package:mercadovila/app/utils/guard/auth_guard.dart';

import 'account_edit_page.dart';

class AccountModule extends Module {
  static const routeName = '/account/';

  @override
  final List<Bind> binds = [
    Bind.factory((i) => AccountEditController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const VendasPage(), guards: [AuthGuard()]),
    ChildRoute('/accounts', child: (_, args) => const AccountsPage(), guards: [AuthGuard()]),
    ChildRoute('/new', child: (_, args) => const AccountEditPage(mySelf: false), guards: [AuthGuard()]),
    ChildRoute('/edit/:id', child: (_, args) => AccountEditPage(id: args.params['id'], mySelf: false), guards: [AuthGuard()]),
    ChildRoute('/edit/self', child: (_, args) => const AccountEditPage(mySelf: true), guards: [AuthGuard()]),
  ];
}
