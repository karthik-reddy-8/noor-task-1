/// email : "noormahammad852@gmail.com"
/// name : "Noor MahammadJalaparthi"
/// password : "Noor@143"
/// phone : "7492749274"
/// photoUrl : "https://firebasestorage.googleapis.com/v0/b/fluttertodo-6dba8.appspot.com/o/Profile-pic%2F5feb4971-7ff8-44bf-9183-f14de602c2157373776070944254049?alt=media&token=b79b01ef-915a-499b-809d-e85f081a0051"

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