part of 'add_expense_bloc.dart';

@immutable
sealed class AddExpenseEvent {
const AddExpenseEvent();

  @override
  List<Object> get props => [];
}

class GivenByChanged extends AddExpenseEvent{
  const GivenByChanged({required this.GivenByEmail});

  final String GivenByEmail;
  @override
  List<Object> get props => [GivenByEmail];
}



class DescriptionChanged extends AddExpenseEvent{
  const DescriptionChanged({required this.Description});


  final String Description;

  @override
  List<Object> get props => [Description];


}



class AmountChanged extends AddExpenseEvent{
  const AmountChanged({required this.Amount});
  final  int Amount ;
  @override
  List<Object> get props => [Amount];

}





class CategoryChanged extends  AddExpenseEvent{
  const CategoryChanged({required this.Category});
   final String Category;
  @override
  List<Object> get props => [Category];

}




class GroupIdChanged extends AddExpenseEvent{
  const GroupIdChanged({required this.GroupId});
   final int GroupId;

  @override
  List<Object> get props => [GroupId];

}
class MembersSelected extends AddExpenseEvent {
  const MembersSelected({required this.selectedMemberIds});

  final List<int> selectedMemberIds;

  @override
  List<Object> get props => [selectedMemberIds];
}


class  ExpenseApi extends AddExpenseEvent{}
class MemberFetched extends AddExpenseEvent{}