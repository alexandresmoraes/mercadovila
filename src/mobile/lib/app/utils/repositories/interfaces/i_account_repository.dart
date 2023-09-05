import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utils/dto/account/account_dto.dart';
import 'package:vilasesmo/app/utils/models/account/new_and_update_account_model.dart';
import 'package:vilasesmo/app/utils/models/account_model.dart';
import 'package:vilasesmo/app/utils/models/paged_result.dart';
import 'package:vilasesmo/app/utils/models/result_fail_model.dart';

abstract class IAccountRepository implements Disposable {
  Future<AccountModel> getAccount(String id);
  Future<Either<ResultFailModel, NewAccountResponseModel>> newAccount(NewAndUpdateAccountModel newAccountModel);
  Future<Either<ResultFailModel, String>> updateAccount(String id, NewAndUpdateAccountModel updateAccountModel);
  Future<PagedResult<AccountDto>> getAccounts(int page, String? usernameOrEmail);
}
