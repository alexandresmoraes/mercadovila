import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/modules/login/login_module.dart';
import 'package:mercadovila/app/utils/http/error_interceptor.dart';
import 'package:mercadovila/app/utils/http/log_interceptor.dart';
import 'package:mercadovila/app/utils/models/login_model.dart';
import 'package:mercadovila/app/utils/models/result_fail_model.dart';
import 'package:mercadovila/app/utils/models/account_model.dart';
import 'package:mercadovila/app/utils/models/access_token_model.dart';
import 'package:mercadovila/app/utils/services/local_storage_service.dart';
import 'interfaces/i_auth_service.dart';

class AuthService implements IAuthService {
  static const _currentToken = 'current_token';

  late final DioForNative dio;
  late final Dio dioWithoutJwt;

  AuthService() {
    dioWithoutJwt = Dio(Modular.get<BaseOptions>());
    dioWithoutJwt.interceptors.add(ErrorInterceptor());
    dioWithoutJwt.interceptors.add(LogInterceptor());
    dioWithoutJwt.interceptors.add(CustomLogInterceptor());
    dio = Modular.get<DioForNative>();
  }

  @override
  void dispose() {}

  @override
  Future<AccountModel> me() async {
    var response = await dio.get('/api/auth/me');

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
  Future<Either<ResultFailModel, AccessTokenModel>> login(LoginModel loginModel) async {
    try {
      var response = await dio.post('/api/auth/login', data: loginModel.toJson());
      var result = AccessTokenModel.fromJson(response.data);
      return Right(result);
    } on DioException catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }

  @override
  Future logout() async {
    await removeCurrentToken();
    Modular.to.navigate(LoginModule.routeName);
  }

  @override
  Future<Either<ResultFailModel, AccessTokenModel>> refreshToken(String refreshTokenModel) async {
    try {
      var response = await dioWithoutJwt.post('/api/auth/refresh-token', data: jsonEncode({'refreshToken': refreshTokenModel}));
      var result = AccessTokenModel.fromJson(response.data);
      return Right(result);
    } on DioException catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }

  @override
  Future removeCurrentToken() async {
    var contains = await LocalStorageService.cointains(_currentToken);
    if (contains) {
      await LocalStorageService.removeValue(_currentToken);
    }
  }

  @override
  Future setCurrentToken(AccessTokenModel token) async => await LocalStorageService.setValue<String>(_currentToken, jsonEncode(token.toJson()));
}
