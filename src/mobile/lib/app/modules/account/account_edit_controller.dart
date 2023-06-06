import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import 'package:string_validator/string_validator.dart';

part 'account_edit_controller.g.dart';

class AccountEditController = _AccountEditControllerBase with _$AccountEditController;

abstract class _AccountEditControllerBase with Store {
  bool isFotoAlterada = false;

  @observable
  String? photoPath;
  @action
  void setPhotoPath(String v) {
    isFotoAlterada = true;
    photoPath = v;
  }

  @observable
  String? nome;
  @observable
  String? _nomeApiError;
  @computed
  String? get getNomeError => _nomeApiError != null && _nomeApiError!.isNotEmpty
      ? _nomeApiError
      : nome != null && nome!.isEmpty
          ? 'Nome do usuário não pode ser vazio.'
          : null;
  @action
  void setNome(String? v) {
    nome = v;
    _nomeApiError = null;
  }

  @observable
  String? username;
  @observable
  String? _usernameApiError;
  @computed
  String? get getUsernameError => _usernameApiError != null && _usernameApiError!.isNotEmpty
      ? _usernameApiError
      : username != null && username!.isEmpty
          ? 'Nome de usuário não pode ser vazio.'
          : null;
  @action
  void setUsername(String? v) {
    username = v;
    _usernameApiError = null;
  }

  @observable
  String? email;
  @observable
  String? _emailApiError;
  @computed
  String? get getEmailError => _emailApiError != null && _emailApiError!.isNotEmpty
      ? _emailApiError
      : email != null && email!.isEmpty
          ? 'Email do usuário não pode ser vazio.'
          : email != null && !isEmail(email!)
              ? 'Insira um email válido.'
              : null;
  @action
  void setEmail(String? v) {
    email = v;
    _emailApiError = null;
  }

  @observable
  String? password;
  @observable
  String? _passwordApiError;
  @computed
  String? get getPasswordError => _passwordApiError != null && _passwordApiError!.isNotEmpty
      ? _passwordApiError
      : password != null && password!.isEmpty
          ? 'Senha do usuário não pode ser vazio.'
          : password != null && password!.length < 4
              ? 'Mínimo 4 caracteres.'
              : password != null && password!.length > 50
                  ? 'Máximo 50 caracteres.'
                  : null;
  @action
  void setPassword(String? v) {
    password = v;
    _passwordApiError = null;
  }

  @observable
  String? confirmPassword;
  @observable
  String? _confirmPasswordApiError;
  @computed
  String? get getConfirmPasswordError => _confirmPasswordApiError != null && _confirmPasswordApiError!.isNotEmpty
      ? _confirmPasswordApiError
      : confirmPassword != null && confirmPassword!.isEmpty
          ? 'Confirme a senha.'
          : confirmPassword != null && password != null && password! != confirmPassword!
              ? 'Senhas não conferem.'
              : null;
  @action
  void setConfirmPassword(String? v) {
    confirmPassword = v;
    _confirmPasswordApiError = null;
  }

  @observable
  String? telefone;
  @observable
  String? _telefoneApiError;
  @computed
  String? get getTelefoneError => _telefoneApiError != null && _telefoneApiError!.isNotEmpty
      ? _telefoneApiError
      : telefone != null && telefone!.isEmpty
          ? 'Número telefone não pode ser vazio.'
          : null;
  @action
  void setTelefone(String? v) {
    telefone = v;
    _telefoneApiError = null;
  }

  @observable
  bool isAtivo = true;
  @action
  void setIsAtivo(bool v) => isAtivo = v;

  @observable
  bool isAdmin = false;
  @action
  void setIsAdmin(bool v) => isAdmin = v;

  @observable
  bool isLoading = false;
  @observable
  bool isPasswordVisible = false;
  @observable
  bool isConfirmPasswordVisible = false;

  @computed
  bool get isValid {
    nome = nome ?? "";
    username = username ?? "";
    email = email ?? "";
    telefone = telefone ?? "";
    password = password ?? "";
    confirmPassword = confirmPassword ?? "";

    return nome != null &&
        username != null &&
        email != null &&
        telefone != null &&
        password != null &&
        confirmPassword != null &&
        getNomeError == null &&
        getUsernameError == null &&
        getTelefoneError == null &&
        getPasswordError == null &&
        getConfirmPasswordError == null &&
        getPasswordError == null &&
        getEmailError == null;
  }

  Future save() async {
    try {
      isLoading = true;

      Future.delayed(const Duration(milliseconds: 5000), () {
        isLoading = false;
      });
    } finally {}
  }
}
