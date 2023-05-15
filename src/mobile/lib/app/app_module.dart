import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/modules/account/account_module.dart';
import 'package:vilasesmo/app/modules/login/login_module.dart';
import 'package:vilasesmo/app/modules/splash/splash_module.dart';
import 'package:vilasesmo/app/stores/account_store.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utility/services/auth_service.dart';
import 'modules/tab/tab_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
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
    BindInject((i) => DioForNative(), isSingleton: true, isLazy: true),
    BindInject((i) => AuthService(), isSingleton: true, isLazy: true)
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: SplashModule()),
    ModuleRoute(TabModule.routeName, module: TabModule()),
    ModuleRoute(LoginModule.routeName, module: LoginModule()),
    ModuleRoute(AccountModule.routeName, module: AccountModule()),
  ];
}
