import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/utils/utils.dart';

part 'login_controller.g.dart';

class LoginController = LoginControllerBase with _$LoginController;

abstract class LoginControllerBase with Store {
  @observable
  String? username;
  @observable
  String? _usernameApiError;
  @computed
  String? get getNomeError => isNullorEmpty(_usernameApiError)
      ? _usernameApiError
      : isNullorEmpty(username)
          ? 'Nome do usuário ou email não pode ser vazio.'
          : null;
  @action
  void setUsername(String? v) {
    username = v;
    _usernameApiError = null;
  }

  @observable
  String? password;
  @observable
  String? _passwordApiError;
  @computed
  String? get getPasswordError => isNullorEmpty(_passwordApiError)
      ? _passwordApiError
      : isNullorEmpty(password)
          ? 'Senha do usuário não pode ser vazio.'
          : null;
  @action
  void setPassword(String? v) {
    password = v;
    _passwordApiError = null;
  }

  @observable
  bool isPasswordVisible = false;
}
