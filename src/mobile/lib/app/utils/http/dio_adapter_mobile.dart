import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

HttpClientAdapter getAdapter() {
  var httpClientAdapter = IOHttpClientAdapter();
  if (kDebugMode) {
    httpClientAdapter.validateCertificate = (_, __, ___) => true;
    httpClientAdapter.createHttpClient = () {
      final HttpClient client = HttpClient(context: SecurityContext(withTrustedRoots: false));
      client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      return client;
    };
  }

  return httpClientAdapter;
}
