// To parse this JSON data, do
//
//     final bankdetailsResponce = bankdetailsResponceFromJson(jsonString);

import 'dart:convert';


class BankdetailsResponce {
  BankdetailsResponce({
    this.loanStatus,
    this.isActive,
    this.createdOn,
    this.id,
    this.loanAmount,
    this.loanFees,
    this.tenure,
    this.productType,
    this.userId,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.docLoanSign,
    this.bankName,
    this.payee,
    this.accountNumber,
  });
  String loanStatus;
  bool isActive;
  DateTime createdOn;
  String id;
  int loanAmount;
  int loanFees;
  int tenure;
  String productType;
  String userId;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String docLoanSign;
  String bankName;
  String payee;
  int accountNumber;

   BankdetailsResponce.fromJson(Map<String, dynamic> json) {

    isActive=json["isActive"];
    createdOn= DateTime.parse(json["createdOn"]);
    id= json["_id"];
    loanAmount= json["loanAmount"];
    loanFees=json["loanFees"];
    tenure= json["tenure"];
    productType= json["productType"];
    userId= json["userId"];
    createdBy= json["createdBy"];
    createdAt=DateTime.parse(json["createdAt"]);
    updatedAt= DateTime.parse(json["updatedAt"]);
    v= json["__v"];
    docLoanSign=json["docLoanSign"];
    bankName= json["bankName"];
    payee= json["payee"];
    accountNumber= json["accountNumber"];
  }
}
