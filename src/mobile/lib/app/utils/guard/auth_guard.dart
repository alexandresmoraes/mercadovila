import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/modules/carrinho/carrinho_store.dart';
import 'package:mercadovila/app/modules/login/login_module.dart';
import 'package:mercadovila/app/stores/account_store.dart';
import 'package:mercadovila/app/utils/services/interfaces/i_auth_service.dart';

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: LoginModule.routeName);

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    debugPrint('-- AuthGuard: $path');

    var accountStore = Modular.get<AccountStore>();
    var authService = Modular.get<IAuthService>();

    if (accountStore.isLogged) {
      return true;
    }

    if (await authService.isAuthenticated()) {
      Modular.get<CarrinhoStore>().load();
      Modular.get<AccountStore>().setAccount(await authService.me());

      return true;
    }

    return false;
  }
}
