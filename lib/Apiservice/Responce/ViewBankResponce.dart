// To parse this JSON data, do
//
//     final viewBankResponce = viewBankResponceFromJson(jsonString);

import 'dart:convert';

ViewBankResponce viewBankResponceFromJson(String str) => ViewBankResponce.fromJson(json.decode(str));

String viewBankResponceToJson(ViewBankResponce data) => json.encode(data.toJson());

class ViewBankResponce {
  ViewBankResponce({
    this.bankDetails,
  });

  List<BankDetail> bankDetails;

  factory ViewBankResponce.fromJson(Map<String, dynamic> json) => ViewBankResponce(
    bankDetails: List<BankDetail>.from(json["bankDetails"].map((x) => BankDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "bankDetails": List<dynamic>.from(bankDetails.map((x) => x.toJson())),
  };
}

class BankDetail {
  BankDetail({
    this.isActive,
    this.createdOn,
    this.id,
    this.bankName,
    this.payee,
    this.accountNumber,
    this.userId,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  bool isActive;
  DateTime createdOn;
  String id;
  String bankName;
  String payee;
  String accountNumber;
  String userId;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory BankDetail.fromJson(Map<String, dynamic> json) => BankDetail(
    isActive: json["isActive"],
    createdOn: DateTime.parse(json["createdOn"]),
    id: json["_id"],
    bankName: json["bankName"],
    payee: json["payee"],
    accountNumber: json["accountNumber"],
    userId: json["userId"],
    createdBy: json["createdBy"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "isActive": isActive,
    "createdOn": createdOn.toIso8601String(),
    "_id": id,
    "bankName": bankName,
    "payee": payee,
    "accountNumber": accountNumber,
    "userId": userId,
    "createdBy": createdBy,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

class BankListRes {
  List<Banklistdetails> projectlistdetails;

  BankListRes({ this.projectlistdetails});

  BankListRes.fromJson(Map<String, dynamic> newsJson)
      : projectlistdetails = List.from(newsJson['bankDetails']).map((projectlistdetails) =>
      Banklistdetails.fromJson(projectlistdetails)).toList();
}
class Banklistdetails {
  bool isActive;
  DateTime createdOn;
  String id;
  String bankName;
  String payee;
  String accountNumber;
  String userId;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  Banklistdetails.fromJson(Map<String, dynamic> json):isActive= json["isActive"],
  createdOn= DateTime.parse(json["createdOn"]),
  id= json["_id"],
  bankName= json["bankName"],
  payee= json["payee"],
  accountNumber= json["accountNumber"],
  userId= json["userId"],
  createdBy= json["createdBy"],
  createdAt= DateTime.parse(json["createdAt"]),
  updatedAt= DateTime.parse(json["updatedAt"]),
  v= json["__v"];
}
