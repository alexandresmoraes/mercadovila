import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:window_manager/window_manager.dart';

import 'app/app_module.dart';
import 'app/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();

    WindowManager.instance.setMinimumSize(const Size(450, 800));
    WindowManager.instance.setMaximumSize(const Size(450, 800));
  }

  timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());

  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
