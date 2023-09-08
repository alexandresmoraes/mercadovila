import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utils/services/interfaces/i_auth_service.dart';
import 'package:vilasesmo/app/utils/utils.dart';

class BearerInterceptor extends InterceptorsWrapper {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
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
        debugPrint("Payload ${tryEncode(options.data)}");
      }
      debugPrint(json.encode("========End Request========"));
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    var authService = Modular.get<IAuthService>();

    try {
      if (err.response?.statusCode == 401) {
        if (await authService.isAuthenticated()) {
          final token = await authService.getCurrentToken();
          final refreshToken = await authService.refreshToken(token!.refreshToken);

          await refreshToken.fold(
            (_) {
              if (kDebugMode) debugPrint(json.encode("========Erro RefreshToken - Redirect Login========"));
              authService.logout();
            },
            (tokenModel) async {
              if (kDebugMode) {
                debugPrint(json.encode("========Refresh Token========"));
                debugPrint("New Token: ${tokenModel.accessToken}");
              }

              authService.setCurrentToken(tokenModel);

              err.requestOptions.headers['Authorization'] = genToken(tokenModel.accessToken);

              try {
                var dio = Modular.get<DioForNative>();
                final response = await dio.fetch(err.requestOptions);
                handler.resolve(response);
              } catch (e) {
                handler.reject(err);
              }
            },
          );
        } else {
          authService.logout();
        }
      } else {
        handler.next(err);
      }
    } catch (e) {
      authService.logout();
    }
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

  String genToken(String token) {
    return 'Bearer $token';
  }
}
