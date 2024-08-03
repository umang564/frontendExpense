import 'package:flutter/material.dart';
import 'package:flutterproject/feature/home/home.dart';
import 'package:flutterproject/screens/app.dart';
import 'package:flutterproject/services/LoginViewModel.dart';
import 'package:provider/provider.dart';
import 'package:flutterproject/services/currentUserForm.dart';
import 'package:flutterproject/services/screenview.dart';
import 'package:flutterproject/feature/login/login.dart';


void main() {
  runApp(


       MyApp(),

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      }, // Home widget where your main app content resides
    );
  }
}
