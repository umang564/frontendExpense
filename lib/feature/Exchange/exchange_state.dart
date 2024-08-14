part of 'exchange_bloc.dart';

@immutable
class ExchangeState extends Equatable {
  final String memberName;
  final int memberId;
  final String memberEmail;
  final int groupId;
  final List<MoneyExchangeModel> exchangeList;
  final String message;
  final ExchangeStatus exchangeStatus;
  final int totalAmount;

  const ExchangeState({
    this.exchangeStatus = ExchangeStatus.loading,
    this.exchangeList = const <MoneyExchangeModel>[],
    this.groupId = 0,
    this.memberName = "",
    this.memberId = 0,
    this.message = "",
    this.memberEmail = "",
    this.totalAmount = 0,
  });

  ExchangeState copyWith({
    String? memberName,
    int? memberId,
    String? memberEmail,
    int? groupId,
    List<MoneyExchangeModel>? exchangeList,
    String? message,
    ExchangeStatus? exchangeStatus,
    int? totalAmount,
  }) {
    return ExchangeState(
      memberName: memberName ?? this.memberName,
      memberId: memberId ?? this.memberId,
      memberEmail: memberEmail ?? this.memberEmail,
      groupId: groupId ?? this.groupId,
      exchangeList: exchangeList ?? this.exchangeList,
      message: message ?? this.message,
      exchangeStatus: exchangeStatus ?? this.exchangeStatus,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  List<Object?> get props => [
    memberName,
    memberId,
    memberEmail,
    groupId,
    exchangeList,
    message,
    exchangeStatus,
    totalAmount,
  ];
}
