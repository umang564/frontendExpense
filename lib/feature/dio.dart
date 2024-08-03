import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Import this for debugPrint

class Api {
  final Dio dio;

  Api() : dio = Dio() {
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
