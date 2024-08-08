part of 'add_member_bloc.dart';


class AddMemberState extends Equatable
{
  const AddMemberState({
    this.group_id=0,
    this.member_name='',
    this.message='',
    this.addMemberStatus=AddMemberStatus.intial

});
    final int group_id;
    final  String member_name;
    final String message;
    final AddMemberStatus addMemberStatus;


    AddMemberState copyWith({
       int? group_id,
       String? member_name,
      String? message,
      AddMemberStatus? addMemberStatus,
}){
      return AddMemberState(
        group_id: group_id ?? this.group_id,
        message: message ?? this.message,
        member_name: member_name ?? this.member_name,
        addMemberStatus: addMemberStatus ?? this.addMemberStatus
      );
    }

  @override
  // TODO: implement props
  List<Object?> get props => [group_id,member_name,message,addMemberStatus];
}


