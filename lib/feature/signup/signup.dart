import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import  'package:flutterproject/feature/signup/signup.dart';
import 'package:flutterproject/feature/signup/signup_bloc.dart';







class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignUpScreen> {
  late SignupBloc _signupBloc;

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final nameFocusNode =FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _signupBloc = SignupBloc();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _signupBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: BlocProvider(
        create: (_) => _signupBloc,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: BlocListener<SignupBloc, SignupState>(
              listenWhen: (previous, current) => current.signupStatus != previous.signupStatus,
              listener: (context, state) {
                if (state.signupStatus == SignupStatus.error) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(content: Text(state.message.toString())),
                    );
                }

                if (state.signupStatus == SignupStatus.success) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('signup successful')),

                    );
                  Navigator.pushNamed(context, '/home');
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<SignupBloc, SignupState>(
                      buildWhen: (current, previous) => current.name  != previous.name,
                      builder: (context, state) {
                        return TextFormField(
                          keyboardType: TextInputType.text,
                          focusNode: nameFocusNode,
                          decoration: const InputDecoration(hintText: 'name', border: OutlineInputBorder()),
                          onChanged: (value) {
                            context.read<SignupBloc>().add(NameChanged(name: value));
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'enter name';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {},
                        );
                      }),
                  const SizedBox(
                    height: 20,
                  ),

                  BlocBuilder<SignupBloc, SignupState>(
                      buildWhen: (current, previous) => current.email != previous.email,
                      builder: (context, state) {
                        return TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          focusNode: emailFocusNode,
                          decoration: const InputDecoration(hintText: 'Email', border: OutlineInputBorder()),
                          onChanged: (value) {
                            context.read<SignupBloc>().add(EmailChanged(email: value));
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter email';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {},
                        );
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<SignupBloc, SignupState>(
                      buildWhen: (current, previous) => current.password != previous.password,
                      builder: (context, state) {
                        return TextFormField(
                          keyboardType: TextInputType.text,
                          focusNode: passwordFocusNode,
                          decoration: const InputDecoration(hintText: 'Password', border: OutlineInputBorder()),
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
                      }),
                  const SizedBox(
                    height: 50,
                  ),
                  BlocBuilder<SignupBloc, SignupState>(
                      buildWhen: (current, previous) => current.signupStatus != previous.signupStatus,
                      builder: (context, state) {
                        return ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<SignupBloc>().add(SignupApi());
                              }
                            },
                            child: state.signupStatus == SignupStatus.loading ? CircularProgressIndicator() : const Text('Sign Up'));
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}