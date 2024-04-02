import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:vilasesmo/app/utils/http/error_interceptor.dart';
import 'package:vilasesmo/app/utils/http/log_interceptor.dart';

import 'bearer_interceptor.dart';

class DioApi extends DioForNative {
  DioApi(BaseOptions options) : super(options) {
    interceptors.add(BearerInterceptor());
    interceptors.add(ErrorInterceptor());
    interceptors.add(LogInterceptor());
    interceptors.add(CustomLogInterceptor());

    HttpClientAdapter client;
    if (kIsWeb) {
      client = BrowserHttpClientAdapter();
    } else {
      client = IOHttpClientAdapter();
    }

    httpClientAdapter = client;
  }
}
