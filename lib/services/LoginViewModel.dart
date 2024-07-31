import 'package:flutter/material.dart';
import 'package:flutterproject/models/LoginUser.dart';
import 'dart:developer';
import 'package:dio/dio.dart';

class LoginViewModel extends ChangeNotifier {
  User _user = User(email: '', password: '');
  bool _isLoading = false;
  String? errorMessage;

  // Getters
  String get email => _user.email;
  String get password => _user.password;
  bool get isLoading => _isLoading;

  // Setters
  void setEmail(String email) {
    _user.email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _user.password = password;
    notifyListeners();
  }

  // Login Method
  Future<bool> login() async {
    _isLoading = true;
    notifyListeners();

    // Preparing the user data
    Map<String, dynamic> userData = {
      'email': _user.email,
      'password': _user.password,
    };

    final Dio _dio = Dio();

    try {
      // Setting headers for the request
      _dio.options.headers = {
        'Content-Type': 'application/json',
      };

      // Making the POST request
      Response response = await _dio.post(
        'http://10.0.2.2:8080/auth/login',
        data: userData,
      );

      // Logging the response
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      return true;
    } catch (e) {
      // Handling errors
      errorMessage='Error: $e';
      print('Error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
