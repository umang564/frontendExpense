part of 'view_member_bloc.dart';

@immutable
sealed class ViewMemberEvent extends Equatable {
  const ViewMemberEvent();

  @override
  List<Object?> get props => [];
}

class MemberFetched extends ViewMemberEvent {}

class GroupIdChanged extends ViewMemberEvent {
  final int group_id;

  const GroupIdChanged({required this.group_id});

  @override
  List<Object?> get props => [group_id];
}
