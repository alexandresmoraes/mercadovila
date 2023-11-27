import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:vilasesmo/app/app_widget.dart';

class ErrorInterceptor extends InterceptorsWrapper {
  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) {
    var error = _handleError(err);

    if (kDebugMode) {
      debugPrint(json.encode("========Begin ErrorInterceptor========"));
      debugPrint(error);
    }

    if (error.isNotEmpty) {
      AnimatedSnackBar.material(
        error,
        type: AnimatedSnackBarType.error,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
      ).show(AppWidget.navigatorKey.currentState!.context);
    }

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
        if (dioError.response!.statusCode == 403) {
          errorDescription = 'Sem permissão';
        } else if (dioError.response!.statusCode != 400 && dioError.response!.statusCode != 413) {
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
