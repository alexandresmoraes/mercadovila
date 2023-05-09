import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<dynamic> getValue<T>(String key) async {
    return await setInstance().then((sharedPreferences) {
      switch (T) {
        case double:
          return sharedPreferences.getDouble(key) ?? 0;
        case int:
          return sharedPreferences.getInt(key) ?? 0;
        case String:
          return sharedPreferences.getString(key) ?? '';
        case List:
          return sharedPreferences.getStringList(key) ?? [];
        case bool:
          return sharedPreferences.getBool(key) ?? false;
        default:
          return sharedPreferences.getString(key) ?? '';
      }
    });
  }

  static Future<void> removeValue(String key) async {
    await setInstance().then((sharedPreferences) => sharedPreferences.remove(key));
  }

  static Future<SharedPreferences> setInstance() async {
    return await SharedPreferences.getInstance();
  }

  static Future<bool> setValue<T>(String key, dynamic value) async {
    return await setInstance().then((sharedPreferences) {
      switch (T) {
        case double:
          return sharedPreferences.setDouble(key, value);
        case int:
          return sharedPreferences.setInt(key, value);
        case String:
          return sharedPreferences.setString(key, value);
        case List:
          return sharedPreferences.setStringList(key, value);
        case bool:
          return sharedPreferences.setBool(key, value);
        default:
          return sharedPreferences.setString(key, value);
      }
    });
  }

  static Future<bool> cointains(String key) async {
    return await setInstance().then((sharedPreferences) {
      return sharedPreferences.containsKey(key);
    });
  }
}
