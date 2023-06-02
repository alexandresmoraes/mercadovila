import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/utility/models/account_model.dart';

part 'account_store.g.dart';

class AccountStore = _AccountStoreBase with _$AccountStore;

abstract class _AccountStoreBase with Store {
  @observable
  AccountModel? account;

  @action
  void setAccount(AccountModel account) => account = account;
}
