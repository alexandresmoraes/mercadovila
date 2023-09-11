import 'dart:convert';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';

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
