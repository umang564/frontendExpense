part of 'exchange_bloc.dart';

@immutable
sealed class ExchangeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MemberNameChanged extends ExchangeEvent {
  final String memberName;

  MemberNameChanged({required this.memberName});

  @override
  List<Object> get props => [memberName];
}

class MemberIdChanged extends ExchangeEvent {
  final int memberId;

  MemberIdChanged({required this.memberId});

  @override
  List<Object> get props => [memberId];
}

class MemberEmailChanged extends ExchangeEvent {
  final String memberEmail;

  MemberEmailChanged({required this.memberEmail});

  @override
  List<Object> get props => [memberEmail];
}

class GroupIdChanged extends ExchangeEvent {
  final int groupId;

  GroupIdChanged({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class FetchExchangeApi extends ExchangeEvent {
  // No additional properties required for this event
}
class WholeSettledApi extends ExchangeEvent{

}


class  NotifyMember extends ExchangeEvent{}
class SettledApi extends  ExchangeEvent{

  final int debitID;
  final String Description;
  final String Category;
  final int  Amount;
  final int ExpenseID;

  SettledApi({ required this.debitID, required this.Category,required this.Amount, required this.Description,required this.ExpenseID});
  @override
  List<Object> get props => [debitID,Category,Description,Amount,ExpenseID];

}