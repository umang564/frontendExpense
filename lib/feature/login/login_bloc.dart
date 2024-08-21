import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterproject/feature/constant.dart';
import 'package:flutterproject/feature/constant.dart';
part 'login_event.dart';
part 'login_state.dart';
final storage = FlutterSecureStorage();

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginApi>(_loginApi);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        email: event.email,
      ),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        password: event.password,
      ),
    );
  }

  Future<void> _loginApi(LoginApi event, Emitter<LoginState> emit) async {
    emit(
      state.copyWith(
        loginStatus: LoginStatus.loading,
      ),
    );
    Map data = {'email': state.email, 'password': state.password};

    final api = Api();

    try {
      final response = await  api.dio.post('$BASE_URL/auth/login',data:data);
      var data1 = response.data;
      if (response.statusCode == 200) {
        String? token = data1['token'];


        if (token != null) {
          // Save the token securely
          await storage.write(key: 'token', value: token);

          emit(
            state.copyWith(
              loginStatus: LoginStatus.success,
              message: 'Login successful',
            ),
          );
        } else {
          emit(
            state.copyWith(
              loginStatus: LoginStatus.error,
              message: 'Token not found',
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            loginStatus: LoginStatus.error,
            message: response.data['error'] ?? 'Login failed',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          loginStatus: LoginStatus.error,
          message: e.toString(),
        ),
      );
    }
  }
}
