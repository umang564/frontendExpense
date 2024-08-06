part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();
  @override
  List<Object> get props => [];
}
class EmailChanged extends SignupEvent {
 const EmailChanged({required this.email});
 final String email;

 @override
 List<Object> get props => [email];
}

class PasswordChanged extends SignupEvent {
 const PasswordChanged({required this.password});

 final String password;

 @override
 List<Object> get props => [password];
}

class NameChanged extends SignupEvent {
 const NameChanged({required this.name});

 final String name;

 @override
 List<Object> get props => [name];
}
class SignupApi extends SignupEvent{

}