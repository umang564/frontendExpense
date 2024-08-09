import 'package:flutter/material.dart';
import 'package:flutterproject/feature/AddMember/addMember.dart';
import 'package:flutterproject/feature/CreateGroup/CreateGroup.dart';
import 'package:flutterproject/feature/GroupPage/Group.dart';
import 'package:flutterproject/feature/ViewMember/viewMember.dart';
import 'package:flutterproject/feature/home/home.dart';
import 'package:flutterproject/screens/app.dart';
import 'package:flutterproject/services/LoginViewModel.dart';
import 'package:provider/provider.dart';
import 'package:flutterproject/services/currentUserForm.dart';
import 'package:flutterproject/services/screenview.dart';
import 'package:flutterproject/feature/login/login.dart';
import 'package:flutterproject/feature/signup/signup.dart';
import 'package:flutterproject/feature/GroupPage/Group.dart';


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
        '/': (context) => SignUpScreen(),
        '/login':(context)=>LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/group':(context)=>GroupDetailScreen(),
        '/createGroup':(context)=>CreateGroupScreen(),
        '/addMember':(context)=>AddMemberScreen(),
        '/viewMember':(context)=>ViewMemberScreen()
      }, // Home widget where your main app content resides
    );
  }
}
