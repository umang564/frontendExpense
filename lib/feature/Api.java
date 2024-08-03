import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Import this for debugPrint

class Api {
  final Dio dio;

  Api() : dio = Dio() {
    dio.options = BaseOptions(
      connectTimeout: 5000, // 5 seconds
      receiveTimeout: 3000, // 3 seconds
    );
    
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

    // Optional: Add a retry interceptor or custom error handling
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioError error) {
          debugPrint('DioError: ${error.message}');
          return error;
        },
        onRequest: (RequestOptions options) {
          debugPrint('Request: ${options.uri}');
          return options;
        },
        onResponse: (Response response) {
          debugPrint('Response: ${response.statusCode}');
          return response;
        },
      ),
    );
  }
}
