part of 'group_bloc.dart';

@immutable
 class GroupState extends Equatable {
  final DeleteStatus deleteStatus;

  const GroupState({
    this.deleteStatus = DeleteStatus.initial,
  });

  GroupState copyWith({
    DeleteStatus? deleteStatus,
  }) {
    return GroupState(
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }

  @override
  List<Object?> get props => [deleteStatus];
}
