class UserSuggestion {
  String? name;
  String? email;

  UserSuggestion({this.name, this.email});

  UserSuggestion.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    email = json['Email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Email'] = this.email;
    return data;
  }
}