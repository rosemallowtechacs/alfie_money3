
import 'dart:convert';

class ForgotPasswordResponce {
  ForgotPasswordResponce({
    this.result,
    this.resultCode,
    this.errors
  });

  String result;
  int resultCode;
  Data errors;
  ForgotPasswordResponce.fromJson(Map<String, dynamic> json)  {
     result= json["result"];
     resultCode= json["resultCode"];
     errors = json['errors'] != null ? new Data.fromJson(json['errors']) : null;
   }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['resultCode'] = this.resultCode;
    data['errors'] = this.errors.toJson();
    return data;
  }
}


class ForgotResponseError {

  Data errors;
  ForgotResponseError({this.errors});

  ForgotResponseError.fromJson(Map<String, dynamic> json) {
    errors = json['errors'] != null ? new Data.fromJson(json['errors']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.errors != null) {
      data['errors'] = this.errors.toJson();
    }
    return data;
  }
}

class Data {
  String msg;
  String param;

  Data({this.msg,this.param});

  Data.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    param = json['param'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['param'] = this.param;
    return data;
  }
}


ForgotPassword forgotPasswordFromJson(String str) => ForgotPassword.fromJson(json.decode(str));

String forgotPasswordToJson(ForgotPassword data) => json.encode(data.toJson());

class ForgotPassword {
  ForgotPassword({
    this.errors,
  });

  List<Error> errors;

  factory ForgotPassword.fromJson(Map<String, dynamic> json) => ForgotPassword(
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