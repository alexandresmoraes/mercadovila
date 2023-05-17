import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/utility/services/local_storage_service.dart';

part 'theme_store.g.dart';

class ThemeStore = _ThemeStoreBase with _$ThemeStore;

abstract class _ThemeStoreBase with Store {
  static const _isDarkModeEnable = '_isDarkModeEnable';

  _ThemeStoreBase() {
    _initStore();
  }

  Future<void> _initStore() async {
    isDarkModeEnable = await getIsDarkModeEnable() ?? true;
  }

  @observable
  bool isDarkModeEnable = true;

  @action
  Future<void> setDarkMode(bool isDarkModeEnable) async {
    await LocalStorageService.setValue<bool>(_isDarkModeEnable, isDarkModeEnable);
    this.isDarkModeEnable = isDarkModeEnable;
  }

  Future<bool?> getIsDarkModeEnable() async {
    var contains = await LocalStorageService.cointains(_isDarkModeEnable);
    if (contains) {
      return await LocalStorageService.getValue<bool>(_isDarkModeEnable);
    } else {
      return null;
    }
  }
}
