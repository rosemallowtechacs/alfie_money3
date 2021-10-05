

class AddBankdetailsRes {
  AddBankdetailsRes({
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

  factory AddBankdetailsRes.fromJson(Map<String, dynamic> json) => AddBankdetailsRes(
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
