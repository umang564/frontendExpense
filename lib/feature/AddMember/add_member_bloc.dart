import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutterproject/feature/constant.dart';

part 'add_member_event.dart';
part 'add_member_state.dart';

class AddMemberBloc extends Bloc<AddMemberEvent, AddMemberState> {
  AddMemberBloc() : super(AddMemberState()) {
    on<MemberNameChanged>(_onMemberChanged);
    on<GroupIdChanged>(_onGroupIdChanged);
    on<AddmemberApi>(_onAddmemberApi);
  }


  void _onMemberChanged(MemberNameChanged event ,Emitter<AddMemberState> emit){
    emit(state.copyWith(member_name: event.add_member_name));
  }

void _onGroupIdChanged(GroupIdChanged event, Emitter<AddMemberState>emit){
    emit(state.copyWith(group_id: event.group_id));
}

  Future<void> _onAddmemberApi(AddmemberApi event, Emitter<AddMemberState> emit) async {
    emit(state.copyWith(addMemberStatus: AddMemberStatus.loading));

    final api = Api();
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      emit(state.copyWith(
        addMemberStatus: AddMemberStatus.error,
        message: "Token Not Found",
      ));
      return;
    }

    print('Retrieved token: $token');

    try {
      int id = state.group_id;
      final response = await api.dio.post(
        "$BASE_URL/user/addmember?id=$id",
        data: {'Email': state.member_name},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(state.copyWith(
          addMemberStatus: AddMemberStatus.success,
          message: "Successfully Created Group",
        ));
      } else if (response.statusCode == 400) {
        emit(state.copyWith(
          addMemberStatus: AddMemberStatus.error,
          message: response.data["message"] ?? "Bad Request",
        ));
      } else if (response.statusCode == 500) {
        emit(state.copyWith(
          addMemberStatus: AddMemberStatus.error,
          message: response.data["message"] ?? "Internal Server Error",
        ));
      } else {
        emit(state.copyWith(
          addMemberStatus: AddMemberStatus.error,
          message: "Unexpected Error: ${response.statusCode}",
        ));
      }
    } catch (e) {
      print('Error: $e'); // Log the error for debugging
      if (e is DioException) {
        final errorMessage = e.response?.data['message'] ?? "An unexpected error occurred";

        emit(state.copyWith(
          addMemberStatus: AddMemberStatus.error,
          message: errorMessage,
        ));


      } else {
        // Handle other types of exceptions
        print('Error: $e');
        emit(state.copyWith(
          addMemberStatus: AddMemberStatus.error,
          message: e.toString(),
        ));
      }
    }
  }

}
