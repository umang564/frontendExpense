part of 'creategroup_bloc.dart';

@immutable
sealed class CreategroupEvent extends Equatable {
  const CreategroupEvent();
  @override
  List<Object> get props => [];
}


class GroupNameChanged extends CreategroupEvent{
  const GroupNameChanged({required this.groupName});
  final String groupName;


  @override
  List<Object> get props => [groupName];

}


class CreateGroupApi extends CreategroupEvent{}
