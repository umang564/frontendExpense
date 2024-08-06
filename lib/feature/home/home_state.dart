part of 'home_bloc.dart';

@immutable
class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class GroupState extends HomeState {
  final GroupStatus groupStatus;
  final List<GroupModel> grouplist;
  final String message;

  const GroupState({
    this.groupStatus = GroupStatus.loading,
    this.grouplist = const <GroupModel>[],
    this.message = '',
  });

  GroupState copyWith({
    GroupStatus? groupStatus,
    List<GroupModel>? grouplist,
    String? message,
  }) {
    return GroupState(
      groupStatus: groupStatus ?? this.groupStatus,
      grouplist: grouplist ?? this.grouplist,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [groupStatus, grouplist, message];
}
