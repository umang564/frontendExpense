import 'package:flutter/material.dart';
import 'package:flutterproject/models/currentuser.dart';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutterproject/models/currentscreen.dart';


class SignUpViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  String name = '';
  String email = '';
  String password = '';
  bool isSignedIn = false;

  void updateName(String value) {
    name = value;
    log('name: $name');

    notifyListeners();
  }

  void updateEmail(String value) {
    email = value;
    log('email : $email');
    notifyListeners();
  }

  void updatePassword(String value) {
    password = value;
    log('password : $password');
    notifyListeners();
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }
void Registeruser(Map<String, dynamic> userData)async{
  final Dio _dio = Dio();
  try {
    // _dio.options.baseUrl = 'http://10.0.2.2:8080/user';
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
    Response response = await _dio.post('http://10.0.2.2:8080/user/createuser', data: userData);
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');

  }catch(e){
    print('Error: $e');

  }

}
  void submitForm()  {
    if (validateForm()) {
      formKey.currentState?.save();
      // Here you can handle the form submission, e.g., send data to an API
      User user = User(name: name, email: email, password: password);

      Map<String, dynamic> userData = {
        'name': user.name,
        'email': user.email,
        'password': user.password,
      };
       Registeruser(userData);

      print('User: ${user.name}, Email: ${user.email}, Password: ${user.password}');
    }
  }
}



