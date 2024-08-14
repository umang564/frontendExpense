class MoneyExchangeModel {
  int? exchangeAmount;
  String? category;
  String? description;
  int? expenseId;
  int? debitId;

  MoneyExchangeModel(
      {this.exchangeAmount,
        this.category,
        this.description,
        this.expenseId,
        this.debitId});

  MoneyExchangeModel.fromJson(Map<String, dynamic> json) {
    exchangeAmount = json['ExchangeAmount'];
    category = json['Category'];
    description = json['Description'];
    expenseId = json['Expense_id'];
    debitId = json['Debit_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ExchangeAmount'] = this.exchangeAmount;
    data['Category'] = this.category;
    data['Description'] = this.description;
    data['Expense_id'] = this.expenseId;
    data['Debit_id'] = this.debitId;
    return data;
  }
}
