// To parse this JSON data, do
//
//     final profiledetails = profiledetailsFromJson(jsonString);

import 'dart:convert';




class Profiledetails1 {
  Profiledetails1({
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
    this.docEKYC,

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
  String docEKYC;


  Profiledetails1.fromJson(Map<String, dynamic> json) {
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
    docSign= json["docSign"];
    docEKYC= json["docEKYC"];

  }


}



class Profiledetails {
  Profiledetails({
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
    this.firstName,
    this.lastName,
    this.icNumber,
    this.dob,
    this.address1,
    this.city,
    this.zipCode,
    this.email,
    this.address2,
    this.facebookId,
    this.docSign,
    this.docEkyc,

    this.education,
    this.employment,
    this.maritalstatus,
    this.numofchild,
    this.docPhoto,
    this.gender,
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
  String education;
  String employment;
  String maritalstatus;
  int numofchild;
  String docPhoto;
  String gender;

  Profiledetails.fromJson(Map<String, dynamic> json) {
    countryCode=json["countryCode"];
    role= json["role"];
    isActive= json["isActive"];
    createdOn= DateTime.parse(json["createdOn"]);
    id= json["_id"];
    mobile= json["mobile"];
    password= json["password"];
    docSign=json["docSign"];
    docEkyc=json["docEKYC"];
    createdAt= DateTime.parse(json["createdAt"]);
    updatedAt= DateTime.parse(json["updatedAt"]);
    v= json["__v"];
    firstName= json["firstName"];
    lastName= json["lastName"];
    icNumber=json["icNumber"];
    dob= json["dob"];
    address1= json["address1"];
    address2=json["address2"];
    city=json["city"];
    zipCode= json["zipCode"];
    email= json["email"];
    facebookId=json["facebookId"];
    education=json["educationLevel"];
    employment= json["employmentStatus"];
    maritalstatus= json["maritalStatus"];
    numofchild=json["numOfChild"];
    docPhoto= json["docPhoto"];
    gender=json["gender"];
  }


}
