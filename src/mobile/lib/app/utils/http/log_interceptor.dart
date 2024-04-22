import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mercadovila/app/utils/utils.dart';

class CustomLogInterceptor extends InterceptorsWrapper {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
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
    }

    super.onRequest(options, handler);

    if (kDebugMode) {
      debugPrint(json.encode("========End Request========"));
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
}
