import 'package:mercadovila/app/modules/notificacoes/notificacoes_edit_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/modules/notificacoes/notificacoes_edit_page.dart';
import 'package:mercadovila/app/modules/notificacoes/notificacoes_page.dart';
import 'package:mercadovila/app/utils/repositories/notificacoes_repository.dart';

class NotificacoesModule extends Module {
  static const routeName = '/notificacoes/';

  @override
  final List<Bind> binds = [
    Bind.factory((i) => NotificacoesEditController()),
    BindInject((i) => NotificacoesRepository(), isSingleton: true, isLazy: true),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const NotificacoesPage(), transition: TransitionType.downToUp, duration: const Duration(milliseconds: 500)),
    ChildRoute('/edit/:id', child: (_, args) => NotificacoesEditPage(id: args.params['id'])),
    ChildRoute('/new', child: (_, args) => const NotificacoesEditPage()),
  ];
}
