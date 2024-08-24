import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:flutterproject/feature/model/viewMemberModel.dart';
import 'package:flutterproject/feature/Repository/viewMember.dart';
import 'package:flutterproject/feature/constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'view_member_event.dart';
part 'view_member_state.dart';

class ViewMemberBloc extends Bloc<ViewMemberEvent, ViewMemberState> {
  ViewMemberBloc() : super(ViewMemberState()) {
    on<MemberFetched>(_onMemberFetched);
    on<GroupIdChanged>(_onGroupIdChanged);
  }



  void _onGroupIdChanged(GroupIdChanged event, Emitter<ViewMemberState>emit){
    emit(state.copyWith(group_id: event.group_id));
  }











Future<void>_onMemberFetched(MemberFetched event ,Emitter<ViewMemberState>emit)async{


  try {
    // Await the result of fetchGroupName
    final memberList = await ViewRepository().fetchMemberGroup(id: state.group_id);
    // Ensure that the emit is called after the future completes
    final storage = FlutterSecureStorage();
    String? x = await storage.read(key: 'current_user_id');

    int? currentUserId;

    if (x != null && x.isNotEmpty) {
      currentUserId = int.tryParse(x);
      emit(state.copyWith(current_user_id: currentUserId));
    }

    if (currentUserId != null) {
      print('Current user ID: $currentUserId');
    } else {
      print('Failed to parse user ID or ID is not set.');
    }
    emit(state.copyWith(
   viewMemberStatus: ViewMemberStatus.success,
      message: 'successful fetching of api',
      memberlist: memberList,
    ));
  } catch (error) {

    // Handle the error and emit the failure state
    emit(state.copyWith(
      viewMemberStatus: ViewMemberStatus.faiure,
      message: error.toString(),
    ));
  }
}








}

