import 'package:vilasesmo/app/modules/login/login_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginModule extends Module {
  static const routeName = '/login';

  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => LoginController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(LoginModule.routeName, module: LoginModule()),
  ];
}
