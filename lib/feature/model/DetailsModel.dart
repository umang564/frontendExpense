class DetailsModel {
  String? givenByName;
  int? amount;
  String? category;
  String? involveUser;
  String? description;
  String? createdAt;

  DetailsModel(
      {this.givenByName,
        this.amount,
        this.category,
        this.involveUser,
        this.description,
        this.createdAt});

  DetailsModel.fromJson(Map<String, dynamic> json) {
    givenByName = json['GivenByName'];
    amount = json['Amount'];
    category = json['Category'];
    involveUser = json['InvolveUser'];
    description = json['Description'];
    createdAt = json['CreatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GivenByName'] = this.givenByName;
    data['Amount'] = this.amount;
    data['Category'] = this.category;
    data['InvolveUser'] = this.involveUser;
    data['Description'] = this.description;
    data['CreatedAt'] = this.createdAt;
    return data;
  }
}
