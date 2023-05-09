import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ErrorInterceptor extends InterceptorsWrapper {
  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint(json.encode("========Begin ErrorInterceptor========"));
      debugPrint(json.encode(_handleError(err)));
    }

    var error = _handleError(err);
    // if (error.isNotEmpty) GlobalSnackbar.error(_handleError(e)).show(); //TODO

    handler.reject(err);

    if (kDebugMode) debugPrint(json.encode("========End ErrorInterceptor========"));

    return;
  }

  String _handleError(DioError dioError) {
    String errorDescription = "";
    switch (dioError.type) {
      case DioErrorType.cancel:
        errorDescription = 'Requisição foi cancelada';
        break;
      case DioErrorType.receiveTimeout:
        errorDescription = 'Tempo limite de conexão esgotado';
        break;
      case DioErrorType.sendTimeout:
        errorDescription = 'Tempo limite de envio em conexão com o servidor';
        break;
      case DioErrorType.connectTimeout:
        errorDescription = 'Tempo limite de conexão esgotado';
        break;
      case DioErrorType.response:
        if (dioError.response!.statusCode != 400) {
          errorDescription = 'Problemas com a conexão';
        }
        break;
      case DioErrorType.other:
        errorDescription = 'Problemas com a conexão';
        break;
    }

    return errorDescription;
  }
}
