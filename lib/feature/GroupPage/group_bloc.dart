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
  Future<void>_onDeleteGroup(DeleteGroup event ,Emitter<GroupState> emit)async{
 emit(state.copyWith(
   deleteStatus: DeleteStatus.loading
 ));
    final api = Api();
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      print(" token not found");
      return;
    }

    print('Retrieved token: $token');
int x= event.groupid;

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
      if (response.statusCode==200){
        emit(state.copyWith(
            deleteStatus: DeleteStatus.success
        ));
        print("successfully deleted");
      }else{
        print("problem in deleting");
      }
  }

}
