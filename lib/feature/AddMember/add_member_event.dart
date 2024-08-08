part of 'add_member_bloc.dart';

@immutable
sealed class AddMemberEvent  extends Equatable {
const AddMemberEvent();
@override
List<Object> get props => [];
}

class  MemberNameChanged extends AddMemberEvent{
 const MemberNameChanged({
   required this.add_member_name
});

  final String add_member_name;
}

class GroupIdChanged extends AddMemberEvent{
  const GroupIdChanged({
    required this.group_id
});


  final int  group_id;
}


class AddmemberApi extends AddMemberEvent{}