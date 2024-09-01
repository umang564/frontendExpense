class SettlementHistory {
  String? oweOrLent;
  int? amount;
  String? category;
  String? createdAt;
  String? deletedAt;

  SettlementHistory(
      {this.oweOrLent,
        this.amount,
        this.category,
        this.createdAt,
        this.deletedAt});

  SettlementHistory.fromJson(Map<String, dynamic> json) {
    oweOrLent = json['OweOrLent'];
    amount = json['Amount'];
    category = json['Category'];
    createdAt = json['CreatedAt'];
    deletedAt = json['DeletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OweOrLent'] = this.oweOrLent;
    data['Amount'] = this.amount;
    data['Category'] = this.category;
    data['CreatedAt'] = this.createdAt;
    data['DeletedAt'] = this.deletedAt;
    return data;
  }
}
