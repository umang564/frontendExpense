import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:flutterproject/feature/constant.dart';
import 'package:dio/dio.dart';
part 'signup_event.dart';
part 'signup_state.dart';


class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupState()) {
   on<EmailChanged>(_onEmailChanged);
   on<PasswordChanged>(_onPasswordChanged);
   on<NameChanged>(_onNameChanged);
   on<SignupApi>(_signupApi);
  }
  void _onEmailChanged(EmailChanged event, Emitter<SignupState> emit) {
    emit(
      state.copyWith(
        email: event.email,
      ),
    );
  }

  void _onPasswordChanged(PasswordChanged event ,Emitter<SignupState>emit){
    emit(state.copyWith(password:event.password,),);
  }


  void _onNameChanged(NameChanged event , Emitter<SignupState> emit)
  {
    emit(state.copyWith(name:event.name,),);
  }



  Future<void> _signupApi(SignupApi event, Emitter<SignupState> emit) async {
    emit(
      state.copyWith(
        signupStatus: SignupStatus.loading,
      ),
    );
    Map data = {'email': state.email, 'password': state.password,'name':state.name};

    final api = Api();

    try {
      final response = await  api.dio.post("$BASE_URL/auth/createuser",data:data);
      var data1 = response.data;
      if (response.statusCode== 2 ||response.statusCode==201) {
        emit(
          state.copyWith(
            signupStatus: SignupStatus.success,
            message: 'signup successful',
          ),
        );
      } else {
        emit(
          state.copyWith(
            signupStatus: SignupStatus.error,
            message:  'signup failed',
          ),
        );
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data['message'] ?? "An unexpected error occurred";

        emit(state.copyWith(
          signupStatus: SignupStatus.error,
          message: errorMessage,
        ));


      } else {
        // Handle other types of exceptions
        print('Error: $e');
        emit(state.copyWith(
          signupStatus: SignupStatus.error,
          message: e.toString(),
        ));
      }
    }
  }

}
