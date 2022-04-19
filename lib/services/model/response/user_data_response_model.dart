class UserDataResponseModel {
  UserDataResponseModel({
      String? email, 
      String? name, 
      String? password, 
      String? phone, 
      String? photoUrl,}){
    _email = email;
    _name = name;
    _password = password;
    _phone = phone;
    _photoUrl = photoUrl;
}

  UserDataResponseModel.fromJson(dynamic json) {
    _email = json['email'];
    _name = json['name'];
    _password = json['password'];
    _phone = json['phone'];
    _photoUrl = json['photoUrl'];
  }
  String? _email;
  String? _name;
  String? _password;
  String? _phone;
  String? _photoUrl;

  String? get email => _email;
  String? get name => _name;
  String? get password => _password;
  String? get phone => _phone;
  String? get photoUrl => _photoUrl;

  Map<String, dynamic> toJson(decode) {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['name'] = _name;
    map['password'] = _password;
    map['phone'] = _phone;
    map['photoUrl'] = _photoUrl;
    return map;
  }

}