import 'package:flutter/material.dart';
import 'package:flutterproject/screens/signup.dart';
import 'package:flutterproject/screens/home.dart';
import 'package:flutterproject/models/currentscreen.dart';

class ScreenViewModel extends ChangeNotifier {
  final Screen _screen = Screen();



  Widget get currentScreen => _screen.currentScreen;

  void switchToHome() {
    _screen.updateScreen(Home());
    notifyListeners();
  }

  void switchToSignUp() {
    _screen.updateScreen(SignUpView());
    notifyListeners();
  }
}
