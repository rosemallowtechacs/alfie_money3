// To parse this JSON data, do
//
//     final bankDetails = bankdetailsFromJson(jsonString);

import 'dart:convert';


class ApplyloanResponce {
  ApplyloanResponce({
    this.loanStatus,
    this.isActive,
    this.createdOn,
    this.id,
    this.loanAmount,
    this.interestRate,
    this.loanFees,
    this.tenure,
    this.productType,
    this.userId,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.profit
  });

  String loanStatus;
  bool isActive;
  DateTime createdOn;
  String id;
  int loanAmount;
  double interestRate;
  int loanFees;
  int tenure;
  int profit;
  String productType;

  String userId;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  ApplyloanResponce.fromJson(Map<String, dynamic> json) {
    loanStatus=json["loanStatus"];
    isActive= json["isActive"];
    createdOn= DateTime.parse(json["createdOn"]);
    id= json["_id"];
    loanAmount= json["loanAmount"];
    interestRate= json["interestRate"].toDouble();
    loanFees= json["loanFees"];
    tenure= json["tenure"];
    productType= json["productType"];
    userId= json["userId"];
    createdBy= json["createdBy"];
    profit=json["profit"];
    createdAt= DateTime.parse(json["createdAt"]);
    updatedAt= DateTime.parse(json["updatedAt"]);
    v=json["__v"];
  }
}
