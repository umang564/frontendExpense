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
        backgroundColor: Colors.blueAccent, // Set the background color of the header
        elevation: 4.0, // Add some shadow to the header
        title: Row(
          children: [
            Text(
              'SignUp', // Display the user's name or a default title
              style: const TextStyle(
                fontSize: 20.0, // Set the font size
                fontWeight: FontWeight.bold, // Make the text bold
                color: Colors.white, // Text color
              ),
            ),
            Spacer(),
            Text(
              'Splito', // Display the user's name or a default title
              style: const TextStyle(
                fontSize: 20.0, // Set the font size
                fontWeight: FontWeight.bold, // Make the text bold
                color: Colors.white, // Text color
              ),
            )


          ],
        ),
      ),
      body: BlocProvider(
        create: (_) => _signupBloc,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: BlocListener<SignupBloc, SignupState>(
                listenWhen: (previous, current) =>
                current.signupStatus != previous.signupStatus,
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
                          const SnackBar(content: Text('Signup successful')));
                    Navigator.pushNamed(context, '/login');
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<SignupBloc, SignupState>(
                      buildWhen: (current, previous) => current.name != previous.name,
                      builder: (context, state) {
                        return TextFormField(
                          keyboardType: TextInputType.text,
                          focusNode: nameFocusNode,
                          decoration: const InputDecoration(
                              hintText: 'Name', border: OutlineInputBorder()),
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
                      buildWhen: (current, previous) =>
                      current.email != previous.email,
                      builder: (context, state) {
                        return TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          focusNode: emailFocusNode,
                          decoration: const InputDecoration(
                              hintText: 'Email', border: OutlineInputBorder()),
                          onChanged: (value) {
                            context.read<SignupBloc>().add(EmailChanged(email: value));
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter email';
                            }
                            // Regular expression for email validation
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
                      buildWhen: (current, previous) =>
                      current.password != previous.password,
                      builder: (context, state) {
                        return TextFormField(
                          keyboardType: TextInputType.text,
                          focusNode: passwordFocusNode,
                          decoration: const InputDecoration(
                              hintText: 'Password', border: OutlineInputBorder()),
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
                      buildWhen: (current, previous) =>
                      current.signupStatus != previous.signupStatus,
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
            ),
          ),
        ),
      ),
    );
  }

}