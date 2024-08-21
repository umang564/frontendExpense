import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterproject/feature/constant.dart';

part 'creategroup_event.dart';
part 'creategroup_state.dart';

class CreategroupBloc extends Bloc<CreategroupEvent, CreategroupState> {
  CreategroupBloc() : super(CreategroupState()) {
    on<GroupNameChanged>(_onGroupChanged);
    on<CreateGroupApi>(_onCreateGroupApi);
  }

  void _onGroupChanged(GroupNameChanged event, Emitter<CreategroupState> emit) {
    emit(state.copyWith(groupName: event.groupName));
  }

  Future<void> _onCreateGroupApi(CreateGroupApi event, Emitter<CreategroupState> emit) async {
    emit(state.copyWith(createGroupStatus: CreateGroupStatus.loading));

    final api = Api();
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      emit(state.copyWith(
        createGroupStatus: CreateGroupStatus.error,
        message: "Token not found",
      ));
      return;
    }

    print('Retrieved token: $token');

    try {
      final response = await api.dio.post(
        "$BASE_URL/user/creategroup",
        data: {'Name': state.groupName},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(state.copyWith(
          createGroupStatus: CreateGroupStatus.success,
          message: "Successfully created group",
        ));
      } else {
        emit(state.copyWith(
          createGroupStatus: CreateGroupStatus.error,
          message: "Failed to create group: ${response.statusMessage}",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        createGroupStatus: CreateGroupStatus.error,
        message: e.toString(),
      ));
    }
  }
}
