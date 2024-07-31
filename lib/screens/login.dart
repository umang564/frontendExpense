import 'package:flutter/material.dart';
import 'package:flutterproject/services/screenview.dart';
import 'package:provider/provider.dart';
import 'package:flutterproject/services/LoginViewModel.dart';
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);
    final screenModel =Provider.of<ScreenViewModel>(context);


    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: viewModel.setEmail,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              onChanged: viewModel.setPassword,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            viewModel.isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: () async {
           bool  success= await viewModel.login();

           if (success){
             screenModel.switchToHome();
           }
           else{
             screenModel.switchToLoginIn();
           }

                // Add navigation or other logic after login
              },
              child: Text(viewModel.errorMessage == null ? 'Login' : viewModel.errorMessage!),
            ),
          ],
        ),
      ),
    );
  }
}
