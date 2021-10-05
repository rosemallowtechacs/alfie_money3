
import 'dart:convert';

class LoginModel {
  LoginModel({
    this.token,

  });

  String token;

   LoginModel.fromJson(Map<String, dynamic> json)  {
     token= json["token"];

   }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;

    return data;
  }
}


Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  Login({
    this.errors,
  });

  List<Error> errors;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    errors: List<Error>.from(json["errors"].map((x) => Error.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "errors": List<dynamic>.from(errors.map((x) => x.toJson())),
  };
}

class Error {
  Error({
    this.msg,
  });

  String msg;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
  };
}
