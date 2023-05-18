import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/notifications/notifications_page.dart';

class NotificationsModule extends Module {
  static const routeName = '/notifications/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const NotificationsPage(), transition: TransitionType.downToUp, duration: const Duration(milliseconds: 500)),
  ];
}
