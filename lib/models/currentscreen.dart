import 'package:flutter/material.dart';
import 'package:flutterproject/screens/signup.dart';

class Screen extends ChangeNotifier {
  Widget _currentScreen = SignUpView();

  Widget get currentScreen => _currentScreen;

  void updateScreen(Widget newScreen) {
    _currentScreen = newScreen;
    notifyListeners();
  }
}
