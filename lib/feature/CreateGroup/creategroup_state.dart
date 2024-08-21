 part of 'creategroup_bloc.dart';



class CreategroupState extends Equatable {
  CreategroupState({
  this.groupName = '',
  this.message = '',
  this.createGroupStatus = CreateGroupStatus.intial,
 });

  String groupName;
 final String message;
  CreateGroupStatus createGroupStatus;

 // CopyWith method for creating a new state with modified values
 CreategroupState copyWith({
  String? groupName,
  String? message,
  CreateGroupStatus? createGroupStatus,
 }) {
  return CreategroupState(
   groupName: groupName ?? this.groupName,
   message: message ?? this.message,
   createGroupStatus: createGroupStatus ?? this.createGroupStatus,
  );
 }

 @override
 List<Object?> get props => [groupName, message, createGroupStatus];
}
