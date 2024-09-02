class Oneoneto {
  int? amount;
  String? groupName;
  String? category;
  String? description;
  String? createdAt;
  String? deletedAt;

  Oneoneto(
      {this.amount,
        this.groupName,
        this.category,
        this.description,
        this.createdAt,
        this.deletedAt});

  Oneoneto.fromJson(Map<String, dynamic> json) {
    amount = json['Amount'];
    groupName = json['GroupName'];
    category = json['Category'];
    description = json['Description'];
    createdAt = json['CreatedAt'];
    deletedAt = json['DeletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Amount'] = this.amount;
    data['GroupName'] = this.groupName;
    data['Category'] = this.category;
    data['Description'] = this.description;
    data['CreatedAt'] = this.createdAt;
    data['DeletedAt'] = this.deletedAt;
    return data;
  }
}
