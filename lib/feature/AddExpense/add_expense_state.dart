part of 'add_expense_bloc.dart';

@immutable
class AddExpenseState extends Equatable {
  const AddExpenseState({
    this.givenBy = '',
    this.amount = 0,
    this.category = '',
    this.description = '',
    this.message = '',
    this.addExpenseStatus = AddExpenseStatus.initial,
    this. groupId=0,
  });

  final String givenBy;
  final int amount;
  final String category;
  final String description;
  final AddExpenseStatus addExpenseStatus;
  final String message;
  final int groupId;

  AddExpenseState copyWith({
    String? givenBy,
    int? amount,
    String? category,
    String? description,
    AddExpenseStatus? addExpenseStatus,
    String? message,
    int?    groupId,
  }) {
    return AddExpenseState(
      givenBy: givenBy ?? this.givenBy,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      addExpenseStatus: addExpenseStatus ?? this.addExpenseStatus,
      message: message ?? this.message,
      groupId: groupId ?? this.groupId,
    );
  }

  @override
  List<Object?> get props => [
    givenBy,
    amount,
    category,
    description,
    addExpenseStatus,
    message,
    groupId
  ];
}
