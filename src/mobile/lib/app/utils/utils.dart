import 'dart:convert';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/stores/theme_store.dart';

bool isNullorEmpty(String? str) {
  return str == null || str.isEmpty;
}

String? tryEncode(data) {
  try {
    return json.decode(data);
  } catch (e) {
    return null;
  }
}

bool isDarkModeEnabled() {
  return Modular.get<ThemeStore>().isDarkModeEnable;
}

String greetingMessage() {
  var h = DateTime.now().hour;
  if (h <= 5) return 'Boa noite';
  if (h < 12) return 'Bom dia';
  if (h < 18) return 'Boa tarde';
  return 'Boa noite';
}
