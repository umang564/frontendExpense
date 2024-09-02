import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/feature/signup/signup.dart';
import 'package:flutterproject/feature/signup/signup_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late SignupBloc _signupBloc;

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final nameFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true; // State variable to manage password visibility

  @override
  void initState() {
    super.initState();
    _signupBloc = SignupBloc();
  }

  @override
  void dispose() {
    _signupBloc.close();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 4.0,
        title: Row(
          children: [
            Text(
              'SignUp',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (_) => _signupBloc,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        'Splito',
                        style: TextStyle(
                          color: Colors.blue.shade500, // Apply blue color (shades of blue)
                          fontSize: 24.0, // Make the font size bigger
                          fontWeight: FontWeight.bold, // Make the text bold
                          fontStyle: FontStyle.italic, // Make the text italic
                        ),
                      ),
                      SizedBox(width: 8.0), // Add some spacing between text and icon
                      Icon(
                        Icons.call_split,
                        color: Colors.blue.shade500, // Apply the same color as the text
                        size: 30.0, // Increase the size of the icon
                      ),
                    ],
                  ),
                  const SizedBox(height: 30), // Space between title and form

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        BlocBuilder<SignupBloc, SignupState>(
                          buildWhen: (current, previous) => current.name != previous.name,
                          builder: (context, state) {
                            return TextFormField(
                              keyboardType: TextInputType.text,
                              focusNode: nameFocusNode,
                              decoration: const InputDecoration(
                                hintText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                context.read<SignupBloc>().add(NameChanged(name: value));
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter name';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {},
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<SignupBloc, SignupState>(
                          buildWhen: (current, previous) => current.email != previous.email,
                          builder: (context, state) {
                            return TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              focusNode: emailFocusNode,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                context.read<SignupBloc>().add(EmailChanged(email: value));
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter email';
                                }
                                final RegExp emailRegex = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                );
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {},
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<SignupBloc, SignupState>(
                          buildWhen: (current, previous) => current.password != previous.password,
                          builder: (context, state) {
                            return TextFormField(
                              keyboardType: TextInputType.text,
                              focusNode: passwordFocusNode,
                              obscureText: _obscurePassword, // Toggle visibility
                              decoration: InputDecoration(
                                hintText: 'Password',
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword; // Toggle visibility
                                    });
                                  },
                                ),
                              ),
                              onChanged: (value) {
                                context.read<SignupBloc>().add(PasswordChanged(password: value));
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter password';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {},
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<SignupBloc, SignupState>(
                          buildWhen: (current, previous) => current.signupStatus != previous.signupStatus,
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<SignupBloc>().add(SignupApi());
                                }
                              },
                              child: state.signupStatus == SignupStatus.loading
                                  ? CircularProgressIndicator()
                                  : const Text('Sign Up'),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<SignupBloc, SignupState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Text("Already a user"),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
