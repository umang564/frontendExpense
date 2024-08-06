part of 'signup_bloc.dart';
enum SignupStatus { initial, loading, success, error }

class SignupState extends Equatable {
  const SignupState({this.name='',this.email='',this.password='',this.message='',this.signupStatus=SignupStatus.initial});
  final String email;
  final String password;
  final String message;
  final String name;
  final SignupStatus signupStatus;

  @override
  List<Object> get props => [email, password, message, name,signupStatus];

  SignupState copyWith({
    String? email,
    String? password,
    String? message,
    String? name,
    SignupStatus? signupStatus
}){
    return(
    SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      message: message ?? this.message,
      name: name ?? this.name,
      signupStatus: signupStatus ?? this.signupStatus,
    )
    );

  }
}


