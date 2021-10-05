// To parse this JSON data, do
//
//     final registerusers = registerusersFromJson(jsonString);


class Registerusers {
  int countryCode;
  String role;
  bool isActive;
  DateTime createdOn;
  String id;
  int mobile;
  String password;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Registerusers({
    this.countryCode,
    this.role,
    this.isActive,
    this.createdOn,
    this.id,
    this.mobile,
    this.password,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Registerusers.fromJson(Map<String, dynamic> json) {
    countryCode= json["countryCode"];
    role= json["role"];
    isActive= json["isActive"];
    createdOn= DateTime.parse(json["createdOn"]);
    id= json["_id"];
    mobile= json["mobile"];
    password= json["password"];
    createdAt= DateTime.parse(json["createdAt"]);
    updatedAt= DateTime.parse(json["updatedAt"]);
    v=json["__v"];
  }
}


