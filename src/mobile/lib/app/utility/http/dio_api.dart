import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:vilasesmo/app/utility/http/error_interceptor.dart';

import 'bearer_interceptor.dart';

class DioApi extends DioForNative {
  DioApi(BaseOptions options) : super(options) {
    interceptors.add(BearerInterceptor());
    interceptors.add(ErrorInterceptor());
  }
}
