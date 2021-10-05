// To parse this JSON data, do
//
//     final getuserdetails = getuserdetailsFromJson(jsonString);

import 'dart:convert';

class Getuserdetails {
  Getuserdetails({
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
    this.docSign,
    this.docEkyc,
    this.firstName,
    this.lastName,
    this.icNumber,
    this.dob,
    this.address1,
    this.address2,
    this.city,
    this.zipCode,
    this.email,
    this.facebookId,
    this.resetPasswordExpires,
    this.resetPasswordToken,
  });



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
  String docSign;
  String docEkyc;
  String firstName;
  String lastName;
  String icNumber;
  String dob;
  String address1;
  String city;
  String zipCode;
  String email;
  String address2;
  String facebookId;
  DateTime resetPasswordExpires;
  String resetPasswordToken;

  Getuserdetails.fromJson(Map<String, dynamic> json) {
    countryCode=json["countryCode"];
    role= json["role"];
    isActive= json["isActive"];
    createdOn= DateTime.parse(json["createdOn"]);
    id= json["_id"];
    mobile= json["mobile"];
    password= json["password"];
    createdAt= DateTime.parse(json["createdAt"]);
    updatedAt= DateTime.parse(json["updatedAt"]);
    v= json["__v"];
    docSign=json["docSign"];
    docEkyc=json["docEKYC"];
    firstName= json["firstName"];
    lastName= json["lastName"];
    icNumber=json["icNumber"];
    dob= json["dob"];
    address1= json["address1"];
    address2=json["address2"];
    city=json["city"];
    zipCode= json["zipCode"];
    email= json["email"];
    resetPasswordExpires= DateTime.parse(json["resetPasswordExpires"]);
    resetPasswordToken= json["resetPasswordToken"];
    facebookId=json["facebookId"];
  }

}

