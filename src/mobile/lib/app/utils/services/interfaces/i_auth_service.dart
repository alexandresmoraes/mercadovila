import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/utils/models/access_token_model.dart';
import 'package:mercadovila/app/utils/models/account_model.dart';
import 'package:mercadovila/app/utils/models/login_model.dart';
import 'package:mercadovila/app/utils/models/result_fail_model.dart';

abstract class IAuthService implements Disposable {
  Future<AccountModel> me();
  Future<AccessTokenModel?> getCurrentToken();
  Future setCurrentToken(AccessTokenModel token);
  Future removeCurrentToken();
  Future<bool> isAuthenticated();
  Future logout();
  Future<Either<ResultFailModel, AccessTokenModel>> login(LoginModel loginModel);
  Future<Either<ResultFailModel, AccessTokenModel>> refreshToken(String refreshTokenModel);
}
