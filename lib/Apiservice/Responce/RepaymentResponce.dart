// To parse this JSON data, do
//
//     final getassignedproject = getassignedprojectFromJson(jsonString);

import 'dart:convert';


class RepaymentPage {
  RepaymentPage({
    this.isActive,
    this.createdOn,
    this.id,
    this.loanId,
    this.paymentDateTime,
    this.emiAmount,
    this.paymentMode,
    this.remarks,
    this.userId,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  bool isActive;
  DateTime createdOn;
  String id;
  String loanId;
  DateTime paymentDateTime;
  int emiAmount;
  String paymentMode;
  String remarks;
  String userId;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory RepaymentPage.fromJson(Map<String, dynamic> json) => RepaymentPage(
    isActive: json["isActive"],
    createdOn: DateTime.parse(json["createdOn"]),
    id: json["_id"],
    loanId: json["loanId"],
    paymentDateTime: DateTime.parse(json["paymentDateTime"]),
    emiAmount: json["emiAmount"],
    paymentMode: json["paymentMode"],
    remarks: json["remarks"],
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
    "loanId": loanId,
    "paymentDateTime": paymentDateTime.toIso8601String(),
    "emiAmount": emiAmount,
    "paymentMode": paymentMode,
    "remarks": remarks,
    "userId": userId,
    "createdBy": createdBy,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
