// To parse this JSON data, do
//
//     final getDisposementLoan = getDisposementLoanFromJson(jsonString);

import 'dart:convert';


class GetDisposementLoan {
  GetDisposementLoan({
    this.loans,
  });

  List<Loan> loans;

  factory GetDisposementLoan.fromJson(Map<String, dynamic> json) => GetDisposementLoan(
    loans: List<Loan>.from(json["loans"].map((x) => Loan.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "loans": List<dynamic>.from(loans.map((x) => x.toJson())),
  };
}

class Loan {
  Loan({
    this.loanStatus,
    this.fundsReceivedFromPartner,
    this.isFundReleased,
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
    this.alfAmountDisburse,
    this.alfDateTime,
    this.alfTransferType,
    this.borrower,
    this.fpAmountReceived,
    this.fpDateTime,
    this.fpFeesDeducted,
    this.refIdOfContract,
    this.docLoanSign,
    this.emiStartDate,
  });

  String loanStatus;
  bool fundsReceivedFromPartner;
  bool isFundReleased;
  bool isActive;
  DateTime createdOn;
  String id;
  int loanAmount;
  double interestRate;
  int loanFees;
  String tenure;
  String productType;
  String userId;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  int alfAmountDisburse;
  DateTime alfDateTime;
  String alfTransferType;
  String borrower;
  int fpAmountReceived;
  DateTime fpDateTime;
  int fpFeesDeducted;
  String refIdOfContract;
  String docLoanSign;
  DateTime emiStartDate;

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
    loanStatus: json["loanStatus"],
    fundsReceivedFromPartner: json["fundsReceivedFromPartner"],
    isFundReleased: json["isFundReleased"],
    isActive: json["isActive"],
    createdOn: DateTime.parse(json["createdOn"]),
    id: json["_id"],
    loanAmount: json["loanAmount"],
    interestRate: json["interestRate"].toDouble(),
    loanFees: json["loanFees"],
    tenure: json["tenure"],
    productType: json["productType"],
    userId: json["userId"],
    createdBy: json["createdBy"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    alfAmountDisburse: json["alfAmountDisburse"],
    alfDateTime: DateTime.parse(json["alfDateTime"]),
    alfTransferType: json["alfTransferType"] == null ? null : json["alfTransferType"],
    borrower: json["borrower"] == null ? null : json["borrower"],
    fpAmountReceived: json["fpAmountReceived"],
    fpDateTime: json["fpDateTime"] == null ? null : DateTime.parse(json["fpDateTime"]),
    fpFeesDeducted: json["fpFeesDeducted"],
    refIdOfContract: json["refIdOfContract"],
    docLoanSign: json["docLoanSign"] == null ? null : json["docLoanSign"],
    emiStartDate: json["emiStartDate"] == null ? null : DateTime.parse(json["emiStartDate"]),
  );

  Map<String, dynamic> toJson() => {
    "loanStatus": loanStatus,
    "fundsReceivedFromPartner": fundsReceivedFromPartner,
    "isFundReleased": isFundReleased,
    "isActive": isActive,
    "createdOn": createdOn.toIso8601String(),
    "_id": id,
    "loanAmount": loanAmount,
    "interestRate": interestRate,
    "loanFees": loanFees,
    "tenure": tenure,
    "productType": productType,
    "userId": userId,
    "createdBy": createdBy,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "alfAmountDisburse": alfAmountDisburse,
    "alfDateTime": alfDateTime.toIso8601String(),
    "alfTransferType": alfTransferType == null ? null : alfTransferType,
    "borrower": borrower == null ? null : borrower,
    "fpAmountReceived": fpAmountReceived,
    "fpDateTime": fpDateTime == null ? null : fpDateTime.toIso8601String(),
    "fpFeesDeducted": fpFeesDeducted,
    "refIdOfContract": refIdOfContract,
    "docLoanSign": docLoanSign == null ? null : docLoanSign,
    "emiStartDate": emiStartDate == null ? null : emiStartDate.toIso8601String(),
  };
}
