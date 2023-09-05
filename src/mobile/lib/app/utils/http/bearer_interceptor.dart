import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/login/login_module.dart';
import 'package:vilasesmo/app/utils/services/interfaces/i_auth_service.dart';

class BearerInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    var authService = Modular.get<IAuthService>();

    if (await authService.isAuthenticated()) {
      var token = await authService.getCurrentToken();
      var headerAuth = genToken(token!.accessToken);
      options.headers['Authorization'] = headerAuth;
    }

    if (kDebugMode) {
      debugPrint(json.encode("========Begin Request========"));
      debugPrint(json.encode("BaseURL: ${options.baseUrl}"));
      debugPrint(json.encode("Endpoint: ${options.path}"));
      if (options.headers['Authorization'] != null) {
        debugPrint("Authorization: ${options.headers['Authorization']}");
      }
      if (options.data != null) {
        // debugPrint("Payload ${json.encode(options.data)}");
      }
      debugPrint(json.encode("========End Request========"));
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint(json.encode("========Begin Response========"));
      if (response.data != null) {
        debugPrint("Payload ${json.encode(response.data)}");
      }
    }

    super.onResponse(response, handler);

    if (kDebugMode) {
      debugPrint(json.encode("========End Response========"));
    }

    return;
  }

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      var options = err.response!.requestOptions;

      if (kDebugMode) {
        debugPrint(json.encode("========Begin Error========"));
        debugPrint(json.encode("BaseURL: ${options.baseUrl}"));
        debugPrint(json.encode("Endpoint: ${options.path}"));
        if (options.headers['Authorization'] != null) {
          debugPrint("Authorization: ${options.headers['Authorization']}");
        }
      }

      var dio = Modular.get<DioForNative>();

      if (kDebugMode) debugPrint(json.encode("========Dio Lock========"));
      dio.lock();
      dio.interceptors.responseLock.lock();
      dio.interceptors.errorLock.lock();

      try {
        var authService = Modular.get<IAuthService>();

        if (await authService.isAuthenticated()) {
          var token = await authService.getCurrentToken();

          if (genToken(token!.accessToken) != options.headers['Authorization']) {
            if (kDebugMode) debugPrint(json.encode("========Update Header Token========"));

            options.headers['Authorization'] = genToken(token.accessToken);

            dio.fetch(options).then(
              (r) {
                return handler.resolve(r);
              },
              onError: (e) {
                return handler.reject(e);
              },
            );
            return;
          }

          (await authService.refreshToken(token.refreshToken)).fold(
            (_) {
              if (kDebugMode) debugPrint(json.encode("========Redirect Login========"));
              authService.logout();
              handler.reject(err);
            },
            (tokenModel) async {
              if (kDebugMode) {
                debugPrint(json.encode("========Refresh Token========"));
                debugPrint("New Token: ${tokenModel.accessToken}");
              }

              authService.setCurrentToken(tokenModel);

              options.headers['Authorization'] = genToken(tokenModel.accessToken);

              dio.fetch(options).then(
                (r) {
                  return handler.resolve(r);
                },
                onError: (e) {
                  return handler.next(e);
                },
              );
            },
          );

          return;
        }
      } finally {
        if (kDebugMode) debugPrint(json.encode("========End Error========"));
        dio.unlock();
        dio.interceptors.responseLock.unlock();
        dio.interceptors.errorLock.unlock();
        if (kDebugMode) debugPrint(json.encode("========Dio Unlock========"));
      }

      Modular.to.navigate(LoginModule.routeName);
      handler.reject(err);
    }

    handler.next(err);
  }

  String genToken(String token) {
    return 'Bearer $token';
  }
}
