import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/feature/login/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc _loginBlocs;

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loginBlocs = LoginBloc();
  }

  @override
  void dispose() {
    _loginBlocs.close();
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
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            const Text(
              'Splito',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (_) => _loginBlocs,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Form(
              key: _formKey,
              child: BlocListener<LoginBloc, LoginState>(
                listenWhen: (previous, current) =>
                current.loginStatus != previous.loginStatus,
                listener: (context, state) {
                  if (state.loginStatus == LoginStatus.error) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(content: Text(state.message.toString())),
                      );
                  }

                  if (state.loginStatus == LoginStatus.success) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(content: Text('Login successful')),
                      );
                    Navigator.pushNamed(context, '/home');
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Splito',
                          style: TextStyle(
                            color: Colors.blue.shade500,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Icon(
                          Icons.call_split,
                          color: Colors.blue.shade500,
                          size: 30.0,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (current, previous) =>
                      current.email != previous.email,
                      builder: (context, state) {
                        return TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          focusNode: emailFocusNode,
                          decoration: const InputDecoration(
                              hintText: 'Email', border: OutlineInputBorder()),
                          onChanged: (value) {
                            context
                                .read<LoginBloc>()
                                .add(EmailChanged(email: value));
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter email';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (current, previous) =>
                      current.password != previous.password,
                      builder: (context, state) {
                        return TextFormField(
                          keyboardType: TextInputType.text,
                          focusNode: passwordFocusNode,
                          obscureText: true,
                          decoration: const InputDecoration(
                              hintText: 'Password', border: OutlineInputBorder()),
                          onChanged: (value) {
                            context
                                .read<LoginBloc>()
                                .add(PasswordChanged(password: value));
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter password';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        Expanded(
                          child: BlocBuilder<LoginBloc, LoginState>(
                            buildWhen: (current, previous) =>
                            current.loginStatus != previous.loginStatus,
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<LoginBloc>().add(LoginApi());
                                  }
                                },
                                child: state.loginStatus == LoginStatus.loading
                                    ? const CircularProgressIndicator()
                                    : const Text('Login'),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/');
                            },
                            child: const Text("Register"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
