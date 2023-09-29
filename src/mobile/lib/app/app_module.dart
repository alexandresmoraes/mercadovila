import 'package:vilasesmo/app/modules/carrinho/carrinho_module.dart';
import 'package:vilasesmo/app/modules/carrinho/carrinho_store.dart';
import 'package:vilasesmo/app/modules/favoritos/favoritos_module.dart';
import 'package:vilasesmo/app/modules/lista_compras/lista_compras_module.dart';
import 'package:vilasesmo/app/modules/minhas_compras/minhas_compras_module.dart';
import 'package:vilasesmo/app/modules/notificacoes/notificacoes_module.dart';
import 'package:vilasesmo/app/modules/pagamentos/pagamentos_module.dart';
import 'package:vilasesmo/app/modules/compras/compras_module.dart';
import 'package:vilasesmo/app/modules/produtos/produtos_edit_controller.dart';
import 'package:vilasesmo/app/modules/produtos/produtos_module.dart';
import 'package:vilasesmo/app/modules/search/search_filter_store.dart';
import 'package:vilasesmo/app/modules/search/search_module.dart';
import 'package:vilasesmo/app/modules/tab/home_page_controller.dart';
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
import 'package:vilasesmo/app/utils/controllers/favorito_controller.dart';
import 'package:vilasesmo/app/utils/http/dio_api.dart';
import 'package:vilasesmo/app/utils/repositories/account_repository.dart';
import 'package:vilasesmo/app/utils/repositories/carrinho_repository.dart';
import 'package:vilasesmo/app/utils/repositories/catalogo_repository.dart';
import 'package:vilasesmo/app/utils/repositories/favoritos_repository.dart';
import 'package:vilasesmo/app/utils/repositories/produtos_repository.dart';
import 'package:vilasesmo/app/utils/services/auth_service.dart';
import 'package:vilasesmo/app/utils/widgets/card_count_produto_controller.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => CarrinhoStore()),
    Bind.lazySingleton((i) => ThemeStore()),
    Bind.lazySingleton((i) => AccountStore()),
    Bind.lazySingleton((i) => SearchFilterStore()),
    Bind.factory((i) => CardCountProdutoController()),
    Bind.factory((i) => FavoritoController()),
    Bind.factory((i) => HomePageController()),
    Bind(
      (i) => BaseOptions(
        baseUrl: kReleaseMode ? 'http://publicado' : 'http://host.docker.internal:8081',
        connectTimeout: kReleaseMode ? 20000 : 0,
        receiveTimeout: kReleaseMode ? 20000 : 0,
        sendTimeout: kReleaseMode ? 20000 : 0,
      ),
    ),
    BindInject((i) => DioApi(i.get<BaseOptions>()), isSingleton: true, isLazy: true),
    BindInject((i) => AuthService(), isSingleton: true, isLazy: true),
    BindInject((i) => AccountRepository(), isSingleton: true, isLazy: true),
    BindInject((i) => CatalogoRepository(), isSingleton: true, isLazy: true),
    BindInject((i) => FavoritosRepository(), isSingleton: true, isLazy: true),
    BindInject((i) => CarrinhoRepository(), isSingleton: true, isLazy: true),
    //TODO: remover itens
    Bind.factory((i) => ProdutosEditController()),
    BindInject((i) => ProdutosRepository(), isSingleton: true, isLazy: true),
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
  ];
}
