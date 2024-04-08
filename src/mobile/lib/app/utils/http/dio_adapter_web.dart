import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

HttpClientAdapter getAdapter() {
  var browserHttpClientAdapter = BrowserHttpClientAdapter();
  if (kDebugMode) browserHttpClientAdapter.withCredentials = false;
  return browserHttpClientAdapter;
}
