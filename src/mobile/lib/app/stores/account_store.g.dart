// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AccountStore on AccountStoreBase, Store {
  late final _$accountAtom =
      Atom(name: 'AccountStoreBase.account', context: context);

  @override
  AccountModel? get account {
    _$accountAtom.reportRead();
    return super.account;
  }

  @override
  set account(AccountModel? value) {
    _$accountAtom.reportWrite(value, super.account, () {
      super.account = value;
    });
  }

  late final _$AccountStoreBaseActionController =
      ActionController(name: 'AccountStoreBase', context: context);

  @override
  void setAccount(AccountModel account) {
    final _$actionInfo = _$AccountStoreBaseActionController.startAction(
        name: 'AccountStoreBase.setAccount');
    try {
      return super.setAccount(account);
    } finally {
      _$AccountStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
account: ${account}
    ''';
  }
}
