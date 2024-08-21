import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:flutterproject/feature/model/groupModel.dart';
import 'package:flutterproject/feature/Repository/groupNames.dart';
import 'package:flutterproject/feature/constant.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, GroupState> {
  GroupRepository groupRepository=GroupRepository();
  HomeBloc() : super((GroupState())) {
    on<GroupFetched>(_GroupFetched);
  }


  Future<void> _GroupFetched(GroupFetched event, Emitter<GroupState> emit) async {
    try {
      // Await the result of fetchGroupName
      final groupList = await groupRepository.fetchGroupName();
      // Ensure that the emit is called after the future completes
      emit(state.copyWith(
        groupStatus: GroupStatus.success,
        message: 'successful fetching of api',
        grouplist: groupList,
      ));
    } catch (error) {

      // Handle the error and emit the failure state
      emit(state.copyWith(
        groupStatus: GroupStatus.failure,
        message: error.toString(),
      ));
    }
  }

}