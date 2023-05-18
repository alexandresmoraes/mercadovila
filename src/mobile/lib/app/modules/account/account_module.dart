import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/account/pages/accounts_page.dart';
import 'package:vilasesmo/app/modules/account/pages/order_details_page.dart';
import 'package:vilasesmo/app/modules/account/pages/orders_page.dart';

import 'pages/account_edit_page.dart';

class AccountModule extends Module {
  static const routeName = '/account/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/accounts', child: (_, args) => const AccountsPage()),
    ChildRoute('/edit', child: (_, args) => const AccountEditPage()),
    ChildRoute('/orders', child: (_, args) => const OrdersPage()),
    ChildRoute('/order-details', child: (_, args) => const OrderDetailsPage()),
  ];
}
