class SettleAmount {
  String? ownByName;
  String? givenByName;
  String? category;
  int? amount;
  String? time;

  SettleAmount(
      {this.ownByName,
        this.givenByName,
        this.category,
        this.amount,
        this.time});

  SettleAmount.fromJson(Map<String, dynamic> json) {
    ownByName = json['OwnByName'];
    givenByName = json['GivenByName'];
    category = json['Category'];
    amount = json['Amount'];
    time = json['Time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OwnByName'] = this.ownByName;
    data['GivenByName'] = this.givenByName;
    data['Category'] = this.category;
    data['Amount'] = this.amount;
    data['Time'] = this.time;
    return data;
  }
}
