import 'dart:convert';

Reciclador recicladorFromJson(String str) => Reciclador.fromJson(json.decode(str));

String recicladorToJson(Reciclador data) => json.encode(data.toJson());

class Reciclador {
  String id;
  String username;
  String email;
  String mobile;
  String password;
  String plate;
  String token;
  String image;

  Reciclador({
    this.id,
    this.username,
    this.email,
    this.mobile,
    this.password,
    this.plate,
    this.token,
    this.image,
  });


  factory Reciclador.fromJson(Map<String, dynamic> json) => Reciclador(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    mobile: json["mobile"],
    password: json["password"],
    plate: json["plate"],
    token: json["token"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
  "id": id,
  "username": username,
  "email": email,
  "mobile": mobile,
  "password": password,
  "plate": plate,
  "token": token,
  "image": image,
  };
}