import 'package:flutter/widgets.dart';
import 'package:vilasesmo/app/modules/carrinho/carrinho_module.dart';
import 'package:vilasesmo/app/modules/carrinho/carrinho_store.dart';
import 'package:vilasesmo/app/modules/favoritos/favoritos_module.dart';
import 'package:vilasesmo/app/modules/lista_compras/lista_compras_module.dart';
import 'package:vilasesmo/app/modules/minhas_compras/minhas_compras_module.dart';
import 'package:vilasesmo/app/modules/notifications/notifications_module.dart';
import 'package:vilasesmo/app/modules/pagamentos/pagamentos_module.dart';
import 'package:vilasesmo/app/modules/pedidos/pedidos_module.dart';
import 'package:vilasesmo/app/modules/produtos/produtos_module.dart';
import 'package:vilasesmo/app/modules/search/search_module.dart';
import 'package:vilasesmo/app/modules/tab/tab_module.dart';
import 'package:vilasesmo/app/modules/vendas/vendas_module.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/modules/account/account_module.dart';
import 'package:vilasesmo/app/modules/login/login_module.dart';
import 'package:vilasesmo/app/modules/splash/splash_module.dart';
import 'package:vilasesmo/app/stores/account_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utility/http/dio_api.dart';
import 'package:vilasesmo/app/utility/services/auth_service.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => CarrinhoStore()),
    Bind.lazySingleton((i) => ThemeStore()),
    Bind.lazySingleton((i) => AccountStore()),
    Bind(
      (i) => BaseOptions(
        baseUrl: kReleaseMode ? 'https://teste' : 'http://192.168.0.100',
        connectTimeout: kReleaseMode ? 20000 : 0,
        receiveTimeout: kReleaseMode ? 20000 : 0,
        sendTimeout: kReleaseMode ? 20000 : 0,
      ),
    ),
    BindInject((i) => DioApi(i.get<BaseOptions>()), isSingleton: true, isLazy: true),
    BindInject((i) => AuthService(), isSingleton: true, isLazy: true),
    Bind<BuildContext>((i) => i.args as BuildContext)
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: SplashModule()),
    ModuleRoute(TabModule.routeName, module: TabModule()),
    ModuleRoute(LoginModule.routeName, module: LoginModule()),
    ModuleRoute(AccountModule.routeName, module: AccountModule()),
    ModuleRoute(CarrinhoModule.routeName, module: CarrinhoModule()),
    ModuleRoute(SearchModule.routeName, module: SearchModule()),
    ModuleRoute(NotificationsModule.routeName, module: NotificationsModule()),
    ModuleRoute(ProdutosModule.routeName, module: ProdutosModule()),
    ModuleRoute(VendasModule.routeName, module: VendasModule()),
    ModuleRoute(PedidosModule.routeName, module: PedidosModule()),
    ModuleRoute(MinhasComprasModule.routeName, module: MinhasComprasModule()),
    ModuleRoute(PagamentosModule.routeName, module: PagamentosModule()),
    ModuleRoute(FavoritosModule.routeName, module: FavoritosModule()),
    ModuleRoute(ListaComprasModule.routeName, module: ListaComprasModule()),
  ];
}
