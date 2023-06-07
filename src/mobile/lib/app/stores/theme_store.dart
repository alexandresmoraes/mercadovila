import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/utils/services/local_storage_service.dart';

part 'theme_store.g.dart';

class ThemeStore = ThemeStoreBase with _$ThemeStore;

abstract class ThemeStoreBase with Store {
  static const _isDarkModeEnable = '_isDarkModeEnable';
  bool defaultIsDarkEnable = true;

  ThemeStoreBase() {
    _initStore();
  }

  Future<void> _initStore() async {
    isDarkModeEnable = await getIsDarkModeEnable();
  }

  @observable
  bool isDarkModeEnable = true;

  @action
  Future<void> setDarkMode(bool isDarkModeEnable) async {
    await LocalStorageService.setValue<bool>(_isDarkModeEnable, isDarkModeEnable);
    this.isDarkModeEnable = isDarkModeEnable;
  }

  Future<bool> getIsDarkModeEnable() async {
    var contains = await LocalStorageService.cointains(_isDarkModeEnable);
    if (contains) {
      return await LocalStorageService.getValue<bool>(_isDarkModeEnable);
    } else {
      return defaultIsDarkEnable;
    }
  }
}
