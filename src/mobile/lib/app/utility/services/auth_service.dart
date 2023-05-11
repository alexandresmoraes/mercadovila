import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utility/http/error_interceptor.dart';
import 'package:vilasesmo/app/utility/models/result_fail_model.dart';
import 'package:vilasesmo/app/utility/models/account_model.dart';
import 'package:vilasesmo/app/utility/models/access_token_model.dart';
import 'package:vilasesmo/app/utility/services/local_storage_service.dart';
import 'interfaces/i_auth_service.dart';

class AuthService implements IAuthService {
  static const _currentToken = 'current_token';

  late final DioForNative dio;
  late final Dio dioWithoutJwt;

  AuthService() {
    dioWithoutJwt = Dio(Modular.get<BaseOptions>());
    dioWithoutJwt.interceptors.add(ErrorInterceptor());
    dio = Modular.get<DioForNative>();
  }

  @override
  void dispose() {}

  @override
  Future<AccountModel> getAccount() async {
    var response = await dio.get('/api/account');

    return AccountModel.fromJson(response.data);
  }

  @override
  Future<AccessTokenModel?> getCurrentToken() async {
    var contains = await LocalStorageService.cointains(_currentToken);
    if (contains) {
      var res = jsonDecode(await LocalStorageService.getValue<String>(_currentToken));
      return AccessTokenModel.fromJson(res);
    } else {
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async => await LocalStorageService.cointains(_currentToken);

  @override
  Future<Either<ResultFailModel, AccessTokenModel>> login(String username, String password) async {
    try {
      var response = await dio.post('/api/auth/login',
          data: FormData.fromMap({'usernameOrEmail': username, 'password': password}));
      var result = AccessTokenModel.fromJson(response.data);
      return Right(result);
    } on DioError catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }

  @override
  Future<void> logout() async {
    await removeCurrentToken();
    // Modular.to.navigate(LoginModule.routeName); //TODO
  }

  @override
  Future<Either<ResultFailModel, AccessTokenModel>> refreshToken(String refreshTokenModel) async {
    try {
      var response =
          await dio.post('/api/auth/refresh-token', data: FormData.fromMap({'refreshToken': refreshTokenModel}));
      var result = AccessTokenModel.fromJson(response.data);
      return Right(result);
    } on DioError catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }

  @override
  Future<void> removeCurrentToken() async {
    var contains = await LocalStorageService.cointains(_currentToken);
    if (contains) {
      await LocalStorageService.removeValue(_currentToken);
    }
  }

  @override
  Future<void> setCurrentToken(AccessTokenModel token) async =>
      await LocalStorageService.setValue<String>(_currentToken, jsonEncode(token.toJson()));
}
