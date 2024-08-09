class ViewMemberModel {
  int? iD;
  String? name;
  String? email;

  ViewMemberModel({this.iD, this.name, this.email});

  ViewMemberModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    email = json['Email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Email'] = this.email;
    return data;
  }
}
