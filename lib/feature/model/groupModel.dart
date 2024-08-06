class GroupModel {
  int? iD;
  String? name;
  int? adminID;

  GroupModel({this.iD, this.name, this.adminID});

  GroupModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    adminID = json['AdminID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['AdminID'] = this.adminID;
    return data;
  }
}
