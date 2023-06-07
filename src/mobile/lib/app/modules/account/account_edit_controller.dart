import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:string_validator/string_validator.dart';
import 'package:vilasesmo/app/stores/account_store.dart';
import 'package:vilasesmo/app/utils/models/account/new_and_update_account_model.dart';
import 'package:vilasesmo/app/utils/models/account_model.dart';
import 'package:vilasesmo/app/utils/models/result_fail_model.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_account_repository.dart';
import 'package:vilasesmo/app/utils/services/interfaces/i_auth_service.dart';
import 'package:vilasesmo/app/utils/utils.dart';
import 'package:vilasesmo/app/utils/widgets/global_snackbar.dart';

part 'account_edit_controller.g.dart';

class AccountEditController = _AccountEditControllerBase with _$AccountEditController;

abstract class _AccountEditControllerBase with Store {
  String? id;

  @observable
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
  String? get getNomeError => isNullorEmpty(_nomeApiError)
      ? _nomeApiError
      : isNullorEmpty(nome)
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
  String? get getUsernameError => isNullorEmpty(_usernameApiError)
      ? _usernameApiError
      : isNullorEmpty(username)
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
  String? get getEmailError => isNullorEmpty(_emailApiError)
      ? _emailApiError
      : isNullorEmpty(email)
          ? 'Email do usuário não pode ser vazio.'
          : !isEmail(email!)
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
  String? get getPasswordError => isNullorEmpty(_passwordApiError)
      ? _passwordApiError
      : isNullorEmpty(password)
          ? 'Senha do usuário não pode ser vazio.'
          : password!.length < 4
              ? 'Mínimo 4 caracteres.'
              : password!.length > 50
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
  String? get getConfirmPasswordError => isNullorEmpty(_confirmPasswordApiError)
      ? _confirmPasswordApiError
      : isNullorEmpty(confirmPassword)
          ? 'Confirme a senha.'
          : password! != confirmPassword!
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
  String? get getTelefoneError => isNullorEmpty(_telefoneApiError)
      ? _telefoneApiError
      : isNullorEmpty(telefone)
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
  bool get isValid =>
      isNullorEmpty(getNomeError) &&
      isNullorEmpty(getUsernameError) &&
      isNullorEmpty(getTelefoneError) &&
      isNullorEmpty(getPasswordError) &&
      isNullorEmpty(getConfirmPasswordError) &&
      isNullorEmpty(getPasswordError) &&
      isNullorEmpty(getEmailError);

  AccountModel? accountModel;

  Future<AccountModel> load() async {
    if (accountModel != null) return accountModel!;

    var accountRepository = Modular.get<IAccountRepository>();
    accountModel = await accountRepository.getAccount(id!);

    nome = accountModel!.nome;
    username = accountModel!.username;
    email = accountModel!.email;
    telefone = accountModel!.telefone;
    password = "";
    confirmPassword = "";

    return accountModel!;
  }

  Future save() async {
    var newAndUpdateAccountModel = NewAndUpdateAccountModel(
      nome: nome!,
      username: username!,
      email: email!,
      telefone: telefone!,
      password: password!,
      confirmPassword: confirmPassword!,
      isActive: true,
      isAdmin: true,
    );

    var accountRepository = Modular.get<IAccountRepository>();
    if (isNullorEmpty(id)) {
      var result = await accountRepository.newAccount(newAndUpdateAccountModel);

      result.fold(apiErrors, (accountResponse) async {
        GlobalSnackbar.success('Alterado com sucesso!');
        Modular.to.pop();
      });
    } else {
      var result = await accountRepository.updateAccount(id!, newAndUpdateAccountModel);

      result.fold(apiErrors, (accountResponse) async {
        var me = await Modular.get<IAuthService>().me();
        result.fold((resultFail) {}, (result) {
          Modular.get<AccountStore>().setAccount(me);
        });

        GlobalSnackbar.success('Alterado com sucesso!');
        Modular.to.pop();
      });
    }
  }

  void apiErrors(ResultFailModel resultFail) {
    if (resultFail.statusCode == 400) {
      _nomeApiError = resultFail.getErrorByProperty('Nome');
      _usernameApiError = resultFail.getErrorByProperty('Username');
      _emailApiError = resultFail.getErrorByProperty('Email');
      _telefoneApiError = resultFail.getErrorByProperty('Telefone');
      _passwordApiError = resultFail.getErrorByProperty('Password');
      _confirmPasswordApiError = resultFail.getErrorByProperty('ConfirmPassword');

      var message = resultFail.getErrorNotProperty();
      if (message.isNotEmpty) GlobalSnackbar.error(message);
    }
  }
}
