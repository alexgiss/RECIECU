import 'dart:convert';
Productor productorFromJson(String str) => Productor.fromJson(json.decode(str));

String productorToJson(Productor data) => json.encode(data.toJson());

class Productor {
  String id;
  String username;
  String email;
  String mobile;
  String password;
  String token;
  String image;

  Productor({
    this.id,
    this.username,
    this.email,
    this.mobile,
    this.password,
    this.token,
    this.image,
  });



  factory Productor.fromJson(Map<String, dynamic> json) => Productor(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    mobile: json["mobile"],
    password: json["password"],
    token: json["token"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "mobile": mobile,
    "password": password,
    "token": token,
    "image": image,
  };
}
