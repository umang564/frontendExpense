part of 'group_bloc.dart';

@immutable
 class GroupState extends Equatable {
 DeleteStatus deleteStatus;
  final int current_user_id;

  GroupState({
    this.deleteStatus = DeleteStatus.initial,
    this.current_user_id=0
  });

  GroupState copyWith({
    DeleteStatus? deleteStatus,
    int? current_user_id
  }) {
    return GroupState(
      deleteStatus: deleteStatus ?? this.deleteStatus,
        current_user_id: current_user_id ?? this.current_user_id
    );
  }

  @override
  List<Object?> get props => [deleteStatus,current_user_id];
}
