// To parse this JSON data, do
//
//     final getLoanDetails = getLoanDetailsFromJson(jsonString);

import 'dart:convert';


class GetLoanDetails {
  GetLoanDetails({
    this.totalPages,
    this.currentPage,
    this.data,
  });

  int totalPages;
  int currentPage;
  List<Datum> data;
  /*GetLoanDetails.fromJson(Map<String, dynamic> newsJson)
      : data = List.from(newsJson['data']).map((data) =>
      Datum.fromJson(data)).toList();*/


  factory GetLoanDetails.fromJson(Map<String, dynamic> json) => GetLoanDetails(
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),);

  Map<String, dynamic> toJson() => {
    "totalPages": totalPages,
    "currentPage": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.loanStatus,
    this.fundsReceivedFromPartner,
    this.isFundReleased,
    this.isActive,
    this.createdOn,
    this.id,
    this.loanAmount,
    this.emiAmount,
    this.profit,
    this.totalDue,
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
    this.emiStartDate,
    this.fpAmountReceived,
    this.fpDateTime,
    this.fpFeesDeducted,
    this.refIdOfContract,
    this.remarks,
    this.docBankStatements,
  });

  String loanStatus;
  bool fundsReceivedFromPartner;
  bool isFundReleased;
  bool isActive;
  DateTime createdOn;
  String id;
  int loanAmount;
  double emiAmount;
  double profit;
  double totalDue;
  double interestRate;
  double loanFees;
  int tenure;
  String productType;
  String userId;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  int alfAmountDisburse;
  DateTime alfDateTime;
  String alfTransferType;
  DateTime emiStartDate;
  int fpAmountReceived;
  dynamic fpDateTime;
  int fpFeesDeducted;
  String refIdOfContract;
  String remarks;
  String docBankStatements;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    loanStatus: json["loanStatus"],
    fundsReceivedFromPartner: json["fundsReceivedFromPartner"],
    isFundReleased: json["isFundReleased"],
    isActive: json["isActive"],
    createdOn: DateTime.parse(json["createdOn"]),
    id: json["_id"],
    loanAmount: json["loanAmount"],
    emiAmount: json["emiAmount"].toDouble(),
    profit: json["profit"].toDouble(),
    totalDue: json["totalDue"].toDouble(),
    interestRate: json["interestRate"].toDouble(),
    loanFees: json["loanFees"].toDouble(),
    tenure: json["tenure"],
    productType: json["productType"],
    userId: json["userId"],
    createdBy: json["createdBy"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    alfAmountDisburse: json["alfAmountDisburse"] == null ? null : json["alfAmountDisburse"],
    alfDateTime: json["alfDateTime"] == null ? null : DateTime.parse(json["alfDateTime"]),
    alfTransferType: json["alfTransferType"] == null ? null : json["alfTransferType"],
    emiStartDate: json["emiStartDate"] == null ? null : DateTime.parse(json["emiStartDate"]),
    fpAmountReceived: json["fpAmountReceived"] == null ? null : json["fpAmountReceived"],
    fpDateTime: json["fpDateTime"]==null?"":json["fpDateTime"],
    fpFeesDeducted: json["fpFeesDeducted"] == null ? null : json["fpFeesDeducted"],
    refIdOfContract: json["refIdOfContract"] == null ? null : json["refIdOfContract"],
    remarks: json["remarks"] == null ? null : json["remarks"],
    docBankStatements: json["docBankStatements"] == null ? null : json["docBankStatements"],
  );

  Map<String, dynamic> toJson() => {
    "loanStatus": loanStatus,
    "fundsReceivedFromPartner": fundsReceivedFromPartner,
    "isFundReleased": isFundReleased,
    "isActive": isActive,
    "createdOn": createdOn.toIso8601String(),
    "_id": id,
    "loanAmount": loanAmount,
    "emiAmount": emiAmount,
    "profit": profit,
    "totalDue": totalDue,
    "interestRate": interestRate,
    "loanFees": loanFees,
    "tenure": tenure,
    "productType": productType,
    "userId": userId,
    "createdBy": createdBy,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "alfAmountDisburse": alfAmountDisburse == null ? null : alfAmountDisburse,
    "alfDateTime": alfDateTime == null ? null : alfDateTime.toIso8601String(),
    "alfTransferType": alfTransferType == null ? null : alfTransferType,
    "emiStartDate": emiStartDate == null ? null : emiStartDate.toIso8601String(),
    "fpAmountReceived": fpAmountReceived == null ? null : fpAmountReceived,
    "fpDateTime": fpDateTime,
    "fpFeesDeducted": fpFeesDeducted == null ? null : fpFeesDeducted,
    "refIdOfContract": refIdOfContract == null ? null : refIdOfContract,
    "remarks": remarks == null ? null : remarks,
    "docBankStatements": docBankStatements == null ? null : docBankStatements,
  };
}

class GetLoanDetails1 {
  GetLoanDetails1({

    this.data,
  });

  List<Datum1> data;
  /*GetLoanDetails.fromJson(Map<String, dynamic> newsJson)
      : data = List.from(newsJson['data']).map((data) =>
      Datum.fromJson(data)).toList();*/


  factory GetLoanDetails1.fromJson(Map<String, dynamic> json) => GetLoanDetails1(
    data: List<Datum1>.from(json["loans"].map((x) => Datum1.fromJson(x))),);

  Map<String, dynamic> toJson() => {
    "loans": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum1 {
  Datum1({
    this.loanStatus,
    this.fundsReceivedFromPartner,
    this.isFundReleased,
    this.isActive,
    this.createdOn,
    this.id,
    this.loanAmount,
    this.emiAmount,
    this.profit,
    this.totalDue,
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
    this.emiStartDate,
    this.fpAmountReceived,
    this.fpDateTime,
    this.fpFeesDeducted,
    this.refIdOfContract,
    this.remarks,
    this.docBankStatements,
  });

  String loanStatus;
  bool fundsReceivedFromPartner;
  bool isFundReleased;
  bool isActive;
  DateTime createdOn;
  String id;
  int loanAmount;
  double emiAmount;
  double profit;
  double totalDue;
  double interestRate;
  double loanFees;
  int tenure;
  String productType;
  String userId;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  int alfAmountDisburse;
  DateTime alfDateTime;
  String alfTransferType;
  DateTime emiStartDate;
  int fpAmountReceived;
  dynamic fpDateTime;
  int fpFeesDeducted;
  String refIdOfContract;
  String remarks;
  String docBankStatements;

  factory Datum1.fromJson(Map<String, dynamic> json) => Datum1(
    loanStatus: json["loanStatus"],
    fundsReceivedFromPartner: json["fundsReceivedFromPartner"],
    isFundReleased: json["isFundReleased"],
    isActive: json["isActive"],
    createdOn: DateTime.parse(json["createdOn"]),
    id: json["_id"],
    loanAmount: json["loanAmount"],
    emiAmount: json["emiAmount"].toDouble(),
    profit: json["profit"].toDouble(),
    totalDue: json["totalDue"].toDouble(),
    interestRate: json["interestRate"].toDouble(),
    loanFees: json["loanFees"].toDouble(),
    tenure: json["tenure"],
    productType: json["productType"],
    userId: json["userId"],
    createdBy: json["createdBy"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    alfAmountDisburse: json["alfAmountDisburse"] == null ? null : json["alfAmountDisburse"],
    alfDateTime: json["alfDateTime"] == null ? null : DateTime.parse(json["alfDateTime"]),
    alfTransferType: json["alfTransferType"] == null ? null : json["alfTransferType"],
    emiStartDate: json["emiStartDate"] == null ? null : DateTime.parse(json["emiStartDate"]),
    fpAmountReceived: json["fpAmountReceived"] == null ? null : json["fpAmountReceived"],
    fpDateTime: json["fpDateTime"]==null?"":json["fpDateTime"],
    fpFeesDeducted: json["fpFeesDeducted"] == null ? null : json["fpFeesDeducted"],
    refIdOfContract: json["refIdOfContract"] == null ? null : json["refIdOfContract"],
    remarks: json["remarks"] == null ? null : json["remarks"],
    docBankStatements: json["docBankStatements"] == null ? null : json["docBankStatements"],
  );

  Map<String, dynamic> toJson() => {
    "loanStatus": loanStatus,
    "fundsReceivedFromPartner": fundsReceivedFromPartner,
    "isFundReleased": isFundReleased,
    "isActive": isActive,
    "createdOn": createdOn.toIso8601String(),
    "_id": id,
    "loanAmount": loanAmount,
    "emiAmount": emiAmount,
    "profit": profit,
    "totalDue": totalDue,
    "interestRate": interestRate,
    "loanFees": loanFees,
    "tenure": tenure,
    "productType": productType,
    "userId": userId,
    "createdBy": createdBy,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "alfAmountDisburse": alfAmountDisburse == null ? null : alfAmountDisburse,
    "alfDateTime": alfDateTime == null ? null : alfDateTime.toIso8601String(),
    "alfTransferType": alfTransferType == null ? null : alfTransferType,
    "emiStartDate": emiStartDate == null ? null : emiStartDate.toIso8601String(),
    "fpAmountReceived": fpAmountReceived == null ? null : fpAmountReceived,
    "fpDateTime": fpDateTime,
    "fpFeesDeducted": fpFeesDeducted == null ? null : fpFeesDeducted,
    "refIdOfContract": refIdOfContract == null ? null : refIdOfContract,
    "remarks": remarks == null ? null : remarks,
    "docBankStatements": docBankStatements == null ? null : docBankStatements,
  };
}

class LoanList {
  List<Projectlistdetails> projectlistdetails;

  LoanList({ this.projectlistdetails});

  LoanList.fromJson(Map<String, dynamic> newsJson)
      : projectlistdetails = List.from(newsJson['loans']).map((projectlistdetails) =>
      Projectlistdetails.fromJson(projectlistdetails)).toList();
}
class Projectlistdetails {
  String loanStatus;
  bool fundsReceivedFromPartner;
  bool isFundReleased;
  bool isActive;
  DateTime createdOn;
  String id;
  int loanAmount;
  double emiAmount;
  double profit;
  double totalDue;
  double interestRate;
  double loanFees;
  int tenure;
  String productType;
  String userId;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  int alfAmountDisburse;
  DateTime alfDateTime;
  String alfTransferType;
  DateTime emiStartDate;
  int fpAmountReceived;
  dynamic fpDateTime;
  int fpFeesDeducted;
  String refIdOfContract;
  String remarks;
  String docBankStatements;
  Projectlistdetails.fromJson(Map<String, dynamic> json):
        loanStatus=json["loanStatus"],
  fundsReceivedFromPartner= json["fundsReceivedFromPartner"],
  isFundReleased=json["isFundReleased"],
  isActive= json["isActive"],
  createdOn= DateTime.parse(json["createdOn"]),
  id= json["_id"],
  loanAmount= json["loanAmount"],
  emiAmount= json["emiAmount"].toDouble(),
  profit= json["profit"].toDouble(),
  totalDue= json["totalDue"].toDouble(),
  interestRate= json["interestRate"].toDouble(),
  loanFees= json["loanFees"].toDouble(),
  tenure= json["tenure"],
  productType= json["productType"],
  userId= json["userId"],
  createdBy= json["createdBy"],
  createdAt= DateTime.parse(json["createdAt"]),
  updatedAt= DateTime.parse(json["updatedAt"]),
  v= json["__v"],
  alfAmountDisburse= json["alfAmountDisburse"] == null ? null : json["alfAmountDisburse"],
  alfDateTime= json["alfDateTime"] == null ? null : DateTime.parse(json["alfDateTime"]),
  alfTransferType= json["alfTransferType"] == null ? null : json["alfTransferType"],
  emiStartDate= json["emiStartDate"] == null ? null : DateTime.parse(json["emiStartDate"]),
  fpAmountReceived= json["fpAmountReceived"] == null ? null : json["fpAmountReceived"],
  fpDateTime= json["fpDateTime"]==null?"":json["fpDateTime"],
  fpFeesDeducted= json["fpFeesDeducted"] == null ? null : json["fpFeesDeducted"],
  refIdOfContract= json["refIdOfContract"] == null ? null : json["refIdOfContract"],
  remarks= json["remarks"] == null ? null : json["remarks"],
  docBankStatements= json["docBankStatements"] == null ? null : json["docBankStatements"];
}
