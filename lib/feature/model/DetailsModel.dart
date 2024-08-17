class DetailsModel {
  String? givenByName;
  int? amount;
  String? category;
  String? description;

  DetailsModel(
      {this.givenByName, this.amount, this.category, this.description});

  DetailsModel.fromJson(Map<String, dynamic> json) {
    givenByName = json['GivenByName'];
    amount = json['Amount'];
    category = json['Category'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GivenByName'] = this.givenByName;
    data['Amount'] = this.amount;
    data['Category'] = this.category;
    data['Description'] = this.description;
    return data;
  }
}
