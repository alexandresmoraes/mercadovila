import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/utils/services/interfaces/i_auth_service.dart';

class BearerInterceptor extends InterceptorsWrapper {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    var authService = Modular.get<IAuthService>();

    if (await authService.isAuthenticated()) {
      var token = await authService.getCurrentToken();
      var headerAuth = genToken(token!.accessToken);
      options.headers['Authorization'] = headerAuth;
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
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
                debugPrint(json.encode("========Success Refresh Token========"));
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

  String genToken(String token) {
    return 'Bearer $token';
  }
}
