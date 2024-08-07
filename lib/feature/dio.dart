import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class Api {
  final Dio dio;
  final CookieJar cookieJar;

  Api()
      : dio = Dio(),
        cookieJar = CookieJar() {
    dio.interceptors.add(CookieManager(cookieJar));
    dio.interceptors.add(

      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (Object object) => debugPrint(object.toString()),
      ),
    );
  }
}
