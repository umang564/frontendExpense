import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:flutterproject/feature/constant.dart';


part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc() : super(GroupState()) {
    on<DeleteGroup>(_onDeleteGroup);
  }
  Future<void> _onDeleteGroup(DeleteGroup event, Emitter<GroupState> emit) async {
    try {
      emit(state.copyWith(deleteStatus: DeleteStatus.loading));

      final api = Api();
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      String? y = await storage.read(key: 'current_user_id');

      int? currentUserId;

      if (y != null && y.isNotEmpty) {
        currentUserId = int.tryParse(y);
        emit(state.copyWith(current_user_id: currentUserId));
      }

      if (currentUserId != null) {
        print('Current user ID: $currentUserId');
      } else {
        print('Failed to parse user ID or ID is not set.');
      }

      if (token == null) {
        print("Token not found");
        return;
      }

      print('Retrieved token: $token');
      int x = event.groupid;

      final response = await api.dio.delete(
        "$BASE_URL/user/deleteGroup?groupid=$x",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Response data: ${response.data}');
      if (response.statusCode == 200) {
        emit(state.copyWith(deleteStatus: DeleteStatus.success));
        print("Successfully deleted");
      } else {
        emit(state.copyWith(deleteStatus: DeleteStatus.failure));
        print("Problem in deleting");
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data['message'] ?? "An unexpected error occurred";

        emit(state.copyWith(
          deleteStatus: DeleteStatus.failure,
          message: errorMessage,
        ));


      } else {
        // Handle other types of exceptions
        print('Error: $e');
        emit(state.copyWith(
          deleteStatus: DeleteStatus.failure,
          message: e.toString(),
        ));
      }
    }
  }

}
