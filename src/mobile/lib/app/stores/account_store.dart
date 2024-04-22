import 'package:mobx/mobx.dart';
import 'package:mercadovila/app/utils/models/account_model.dart';

part 'account_store.g.dart';

class AccountStore = AccountStoreBase with _$AccountStore;

abstract class AccountStoreBase with Store {
  @observable
  AccountModel? account;

  @action
  void setAccount(AccountModel account) => this.account = account;
}
