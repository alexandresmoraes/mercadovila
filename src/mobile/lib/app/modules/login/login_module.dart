import 'package:mercadovila/app/modules/login/login_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/modules/login/login_page.dart';

class LoginModule extends Module {
  static const routeName = '/login/';

  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => LoginController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => const LoginPage(), transition: TransitionType.fadeIn, duration: const Duration(seconds: 2)),
  ];
}
