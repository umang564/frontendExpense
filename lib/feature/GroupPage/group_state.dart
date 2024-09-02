part of 'group_bloc.dart';

@immutable
 class GroupState extends Equatable {
 DeleteStatus deleteStatus;
  final int current_user_id;
   final String message;


  GroupState({
    this.deleteStatus = DeleteStatus.initial,
    this.current_user_id=0,
    this.message=''
  });

  GroupState copyWith({
    DeleteStatus? deleteStatus,
    int? current_user_id,
    String? message
  }) {
    return GroupState(
      deleteStatus: deleteStatus ?? this.deleteStatus,
        current_user_id: current_user_id ?? this.current_user_id,
        message: message ?? this.message
    );
  }

  @override
  List<Object?> get props => [deleteStatus,current_user_id,message];
}
