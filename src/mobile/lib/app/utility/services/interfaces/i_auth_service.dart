import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utility/models/access_token_model.dart';
import 'package:vilasesmo/app/utility/models/account_model.dart';
import 'package:vilasesmo/app/utility/models/result_fail_model.dart';

abstract class IAuthService implements Disposable {
  Future<AccountModel> getAccount();
  Future<AccessTokenModel?> getCurrentToken();
  Future<void> setCurrentToken(AccessTokenModel token);
  Future<void> removeCurrentToken();
  Future<bool> isAuthenticated();
  Future<void> logout();
  Future<Either<ResultFailModel, AccessTokenModel>> login(String username, String password);
  Future<Either<ResultFailModel, AccessTokenModel>> refreshToken(String refreshTokenModel);
}
