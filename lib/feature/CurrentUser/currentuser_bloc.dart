import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:dio/dio.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterproject/feature/constant.dart';

part 'currentuser_event.dart';
part 'currentuser_state.dart';

class CurrentuserBloc extends Bloc<CurrentuserEvent, CurrentuserState> {
  CurrentuserBloc() : super(CurrentuserState()) {
    on<FetchCurrentUserDetails>(_onFetchCurrentUserDetails);
  }


  Future<void> _onFetchCurrentUserDetails(FetchCurrentUserDetails event,
      Emitter<CurrentuserState>emit) async {
    emit(state.copyWith(currentUserStatus: CurrentUserStatus.loading));
    final api = Api();
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      emit(state.copyWith(
        currentUserStatus: CurrentUserStatus.error,
      ));
      return;
    }

    print('Retrieved token: $token');













  }
}