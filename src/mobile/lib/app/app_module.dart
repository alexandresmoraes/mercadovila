import 'package:vilasesmo/app/modules/carrinho/carrinho_module.dart';
import 'package:vilasesmo/app/modules/carrinho/carrinho_store.dart';
import 'package:vilasesmo/app/modules/compras/compras_carrinho_store.dart';
import 'package:vilasesmo/app/modules/favoritos/favoritos_module.dart';
import 'package:vilasesmo/app/modules/lista_compras/lista_compras_module.dart';
import 'package:vilasesmo/app/modules/meus_pagamentos/meus_pagamentos_module.dart';
import 'package:vilasesmo/app/modules/minhas_compras/minhas_compras_module.dart';
import 'package:vilasesmo/app/modules/notificacoes/notificacoes_module.dart';
import 'package:vilasesmo/app/modules/pagamentos/pagamentos_module.dart';
import 'package:vilasesmo/app/modules/compras/compras_module.dart';
import 'package:vilasesmo/app/modules/produtos/produtos_module.dart';
import 'package:vilasesmo/app/modules/search/search_filter_store.dart';
import 'package:vilasesmo/app/modules/search/search_module.dart';
import 'package:vilasesmo/app/modules/tab/home_page_controller.dart';
import 'package:vilasesmo/app/modules/tab/tab_module.dart';
import 'package:vilasesmo/app/modules/vendas/vendas_module.dart';
import 'package:vilasesmo/app/stores/pagamentos_store.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/modules/account/account_module.dart';
import 'package:vilasesmo/app/modules/login/login_module.dart';
import 'package:vilasesmo/app/modules/splash/splash_module.dart';
import 'package:vilasesmo/app/stores/account_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utils/controllers/favorito_controller.dart';
import 'package:vilasesmo/app/utils/http/dio_api.dart';
import 'package:vilasesmo/app/utils/repositories/account_repository.dart';
import 'package:vilasesmo/app/utils/repositories/carrinho_repository.dart';
import 'package:vilasesmo/app/utils/repositories/catalogo_repository.dart';
import 'package:vilasesmo/app/utils/repositories/compras_repository.dart';
import 'package:vilasesmo/app/utils/repositories/favoritos_repository.dart';
import 'package:vilasesmo/app/utils/repositories/pagamentos_repository.dart';
import 'package:vilasesmo/app/utils/repositories/produtos_repository.dart';
import 'package:vilasesmo/app/utils/repositories/rating_item_repository.dart';
import 'package:vilasesmo/app/utils/repositories/vendas_repository.dart';
import 'package:vilasesmo/app/utils/services/auth_service.dart';
import 'package:vilasesmo/app/utils/widgets/card_count_produto_controller.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => DioApi(i.get<BaseOptions>())),
    Bind(
      (i) => BaseOptions(
        baseUrl: kReleaseMode ? 'https://vila.sesmo.com.br' : 'http://192.168.0.100:8081',
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
    ModuleRoute(TabModule.routeName, module: TabModule()),
    ModuleRoute(LoginModule.routeName, module: LoginModule()),
    ModuleRoute(AccountModule.routeName, module: AccountModule()),
    ModuleRoute(CarrinhoModule.routeName, module: CarrinhoModule()),
    ModuleRoute(SearchModule.routeName, module: SearchModule()),
    ModuleRoute(ProdutosModule.routeName, module: ProdutosModule()),
    ModuleRoute(VendasModule.routeName, module: VendasModule()),
    ModuleRoute(ComprasModule.routeName, module: ComprasModule()),
    ModuleRoute(MinhasComprasModule.routeName, module: MinhasComprasModule()),
    ModuleRoute(PagamentosModule.routeName, module: PagamentosModule()),
    ModuleRoute(FavoritosModule.routeName, module: FavoritosModule()),
    ModuleRoute(ListaComprasModule.routeName, module: ListaComprasModule()),
    ModuleRoute(NotificacoesModule.routeName, module: NotificacoesModule()),
    ModuleRoute(MeusPagamentosModule.routeName, module: MeusPagamentosModule()),
  ];
}
