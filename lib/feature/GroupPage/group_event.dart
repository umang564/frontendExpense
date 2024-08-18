part of 'group_bloc.dart';

@immutable
sealed class GroupEvent extends Equatable {}
class DeleteGroup extends GroupEvent{
  DeleteGroup({required this.groupid});
  final int groupid;
  @override
  // TODO: implement props
  List<Object?> get props =>[groupid] ;

}
