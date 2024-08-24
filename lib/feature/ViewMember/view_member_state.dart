part of 'view_member_bloc.dart';

@immutable
class ViewMemberState extends Equatable {
  final ViewMemberStatus viewMemberStatus;
  final String message;
  final List<ViewMemberModel> memberlist;
  final int group_id;
  final int current_user_id;

  const ViewMemberState({
    this.viewMemberStatus = ViewMemberStatus.loading,
    this.message = "",
    this.memberlist = const <ViewMemberModel>[],
    this.group_id=0,
    this.current_user_id=0

  });

  ViewMemberState copyWith({
    ViewMemberStatus? viewMemberStatus,
    String? message,
    List<ViewMemberModel>? memberlist,
    int? group_id,
    int? current_user_id
  }) {
    return ViewMemberState(
      viewMemberStatus: viewMemberStatus ?? this.viewMemberStatus,
      message: message ?? this.message,
      memberlist: memberlist ?? this.memberlist,
      group_id: group_id ?? this.group_id,
      current_user_id: current_user_id ?? this.current_user_id
    );
  }

  @override
  List<Object?> get props => [viewMemberStatus, message, memberlist,group_id,current_user_id];
}
