import 'dart:convert';

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
