
import 'dart:convert';

class ChangePasswordResponce {
  ChangePasswordResponce({
    this.result,
    this.resultCode,
  });

  String result;
  int resultCode;
  ChangePasswordResponce.fromJson(Map<String, dynamic> json)  {
    result= json["result"];
    resultCode= json["resultCode"];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['resultCode'] = this.resultCode;

    return data;
  }
}


ChangePassword changePasswordFromJson(String str) => ChangePassword.fromJson(json.decode(str));

String forgotPasswordToJson(ChangePassword data) => json.encode(data.toJson());

class ChangePassword {
  ChangePassword({
    this.errors,
  });

  List<Error> errors;

  factory ChangePassword.fromJson(Map<String, dynamic> json) => ChangePassword(
    errors: List<Error>.from(json["errors"].map((x) => Error.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "errors": List<dynamic>.from(errors.map((x) => x.toJson())),
  };
}

class Error {
  Error({
    this.msg,
    this.param,
  });

  String msg;
  String param;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    msg: json["msg"],
    param: json["param"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "param": param,
  };
}
