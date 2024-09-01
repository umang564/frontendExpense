import 'package:flutter/material.dart';
import 'package:flutterproject/feature/AddMember/addMember.dart';
import 'package:flutterproject/feature/CreateGroup/CreateGroup.dart';
import 'package:flutterproject/feature/Exchange/exchange.dart';
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
import 'package:flutterproject/feature/AddExpense/addexpense.dart';
import 'package:flutterproject/feature/GroupDetails/Groupdetails.dart';
import 'package:flutterproject/feature/GroupDetails/csv.dart';
import 'package:flutterproject/feature/CurrentUser/currentuser_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/feature/Profile.dart';
import 'package:flutterproject/feature/Settledhistory.dart';
import 'package:flutterproject/feature/UserExpenseHistory.dart';


void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CurrentuserBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        initialRoute: '/',
        routes: {
          '/': (context) => SignUpScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/group': (context) => GroupDetailScreen(),
          '/createGroup': (context) => CreateGroupScreen(),
          '/addMember': (context) => AddMemberScreen(),
          '/viewMember': (context) => ViewMemberScreen(),
          '/addexpense': (context) => AddExpenseScreen(),
          '/exchange': (context) => ExchangeScreen(),
          '/details': (context) => GroupdetailsScreen(),
          '/csv': (context) => CsvGeneratorPage(),
          '/profile':(context )=>ProfilePage(),
          '/SettledHistory':(context)=>Settledhistory(),
          '/expense':(context)=>UserExpenseHistory()
        }, // Home widget where your main app content resides
      ),
    );
  }
}
