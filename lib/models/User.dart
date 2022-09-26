import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id = 0,
    this.userName = '',
    this.password = '',
    this.email = '',
    this.phone = '',
    this.university = '',
    this.province = '',
    this.district = '',
    this.supervisorEmail = ''
  });
  //constructor

  int id;
  String userName;
  String password;
  String email;
  String phone;
  String university;
  String province;
  String district;
  String supervisorEmail;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    userName: json["userName"],
    password: json["password"],
    email: json["email"],
    phone: json["phone"],
    university: json["university"],
    province: json["province"],
    district: json["district"],
    supervisorEmail: json["supervisorEmail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userName": userName,
    "password": password,
    "email": email,
    "phone": phone,
    "university": university,
    "province": province,
    "district": district,
    "supervisorEmail": supervisorEmail,
  };
}
