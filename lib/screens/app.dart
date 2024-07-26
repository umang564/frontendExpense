import 'package:flutter/material.dart';
import 'package:flutterproject/screens/home.dart';
import 'package:flutterproject/screens/signup.dart';
import 'package:provider/provider.dart';
import 'package:flutterproject/services/currentUserForm.dart';
import 'package:flutterproject/services/screenview.dart';


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ScreenViewModel>(context);

    return viewModel.currentScreen ;
  }
}
