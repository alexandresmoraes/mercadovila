import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/modules/account/account_module.dart';
import 'package:mercadovila/app/modules/carrinho/carrinho_module.dart';
import 'package:mercadovila/app/modules/carrinho/carrinho_store.dart';
import 'package:mercadovila/app/modules/compras/compras_carrinho_store.dart';
import 'package:mercadovila/app/modules/compras/compras_module.dart';
import 'package:mercadovila/app/modules/favoritos/favoritos_module.dart';
import 'package:mercadovila/app/modules/lista_compras/lista_compras_module.dart';
import 'package:mercadovila/app/modules/login/login_module.dart';
import 'package:mercadovila/app/modules/meus_pagamentos/meus_pagamentos_module.dart';
import 'package:mercadovila/app/modules/minhas_compras/minhas_compras_module.dart';
import 'package:mercadovila/app/modules/notificacoes/notificacoes_module.dart';
import 'package:mercadovila/app/modules/pagamentos/pagamentos_module.dart';
import 'package:mercadovila/app/modules/produtos/produtos_module.dart';
import 'package:mercadovila/app/modules/search/search_filter_store.dart';
import 'package:mercadovila/app/modules/search/search_module.dart';
import 'package:mercadovila/app/modules/splash/splash_module.dart';
import 'package:mercadovila/app/modules/tab/home_page_controller.dart';
import 'package:mercadovila/app/modules/tab/tab_module.dart';
import 'package:mercadovila/app/modules/vendas/vendas_module.dart';
import 'package:mercadovila/app/stores/account_store.dart';
import 'package:mercadovila/app/stores/pagamentos_store.dart';
import 'package:mercadovila/app/stores/theme_store.dart';
import 'package:mercadovila/app/utils/controllers/favorito_controller.dart';
import 'package:mercadovila/app/utils/guard/auth_guard.dart';
import 'package:mercadovila/app/utils/http/dio_api.dart';
import 'package:mercadovila/app/utils/repositories/account_repository.dart';
import 'package:mercadovila/app/utils/repositories/carrinho_repository.dart';
import 'package:mercadovila/app/utils/repositories/catalogo_repository.dart';
import 'package:mercadovila/app/utils/repositories/compras_repository.dart';
import 'package:mercadovila/app/utils/repositories/favoritos_repository.dart';
import 'package:mercadovila/app/utils/repositories/pagamentos_repository.dart';
import 'package:mercadovila/app/utils/repositories/produtos_repository.dart';
import 'package:mercadovila/app/utils/repositories/rating_item_repository.dart';
import 'package:mercadovila/app/utils/repositories/vendas_repository.dart';
import 'package:mercadovila/app/utils/services/auth_service.dart';
import 'package:mercadovila/app/utils/utils.dart';
import 'package:mercadovila/app/utils/widgets/card_count_produto_controller.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => DioApi(i.get<BaseOptions>())),
    Bind(
      (i) => BaseOptions(
        baseUrl: getBaseUrl(),
        connectTimeout: const Duration(milliseconds: kReleaseMode ? 20000 : 60000),
        receiveTimeout: const Duration(milliseconds: kReleaseMode ? 20000 : 60000),
        sendTimeout: const Duration(milliseconds: kReleaseMode ? 20000 : 60000),
      ),
    ),
    Bind.lazySingleton((i) => CarrinhoStore()),
    Bind.lazySingleton((i) => ComprasCarrinhoStore()),
    Bind.singleton((i) => ThemeStore()),
    Bind.lazySingleton((i) => AccountStore()),
    Bind.lazySingleton((i) => SearchFilterStore()),
    Bind.lazySingleton((i) => PagamentosStore()),
    Bind.factory((i) => CardCountProdutoController()),
    Bind.factory((i) => FavoritoController()),
    Bind.factory((i) => HomePageController()),
    Bind.lazySingleton((i) => AuthService()),
    Bind.lazySingleton((i) => AccountRepository()),
    Bind.lazySingleton((i) => CatalogoRepository()),
    Bind.lazySingleton((i) => FavoritosRepository()),
    Bind.lazySingleton((i) => CarrinhoRepository()),
    Bind.lazySingleton((i) => VendasRepository()),
    Bind.lazySingleton((i) => ComprasRepository()),
    Bind.lazySingleton((i) => PagamentosRepository()),
    Bind.lazySingleton((i) => ProdutosRepository()),
    Bind.lazySingleton((i) => RatingRepository()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: SplashModule()),
    ModuleRoute(TabModule.routeName, module: TabModule(), guards: [AuthGuard()]),
    ModuleRoute(LoginModule.routeName, module: LoginModule()),
    ModuleRoute(AccountModule.routeName, module: AccountModule(), guards: [AuthGuard()]),
    ModuleRoute(CarrinhoModule.routeName, module: CarrinhoModule(), guards: [AuthGuard()]),
    ModuleRoute(SearchModule.routeName, module: SearchModule(), guards: [AuthGuard()]),
    ModuleRoute(ProdutosModule.routeName, module: ProdutosModule(), guards: [AuthGuard()]),
    ModuleRoute(VendasModule.routeName, module: VendasModule(), guards: [AuthGuard()]),
    ModuleRoute(ComprasModule.routeName, module: ComprasModule(), guards: [AuthGuard()]),
    ModuleRoute(MinhasComprasModule.routeName, module: MinhasComprasModule(), guards: [AuthGuard()]),
    ModuleRoute(PagamentosModule.routeName, module: PagamentosModule(), guards: [AuthGuard()]),
    ModuleRoute(FavoritosModule.routeName, module: FavoritosModule(), guards: [AuthGuard()]),
    ModuleRoute(ListaComprasModule.routeName, module: ListaComprasModule(), guards: [AuthGuard()]),
    ModuleRoute(NotificacoesModule.routeName, module: NotificacoesModule(), guards: [AuthGuard()]),
    ModuleRoute(MeusPagamentosModule.routeName, module: MeusPagamentosModule(), guards: [AuthGuard()]),
  ];
}
