// To parse this JSON data, do
//
//     final loanStatus = loanStatusFromJson(jsonString);

import 'dart:convert';

LoanDetails loanStatusFromJson(String str) => LoanDetails.fromJson(json.decode(str));

String loanStatusToJson(LoanDetails data) => json.encode(data.toJson());

class LoanDetails {
  LoanDetails({
    this.activeLoans,
    this.numOfLoans,
    this.anyLatePayments,
    this.anyDefaults,
    this.numOfRejectedLoans,
    this.rejectedLoans,
  });

  List<Loan> activeLoans;
  List<Loan> numOfLoans;
  String anyLatePayments;
  String anyDefaults;
  int numOfRejectedLoans;
  List<RejectedLoan> rejectedLoans;

  factory LoanDetails.fromJson(Map<String, dynamic> json) => LoanDetails(
    activeLoans: List<Loan>.from(json["activeLoans"].map((x) => Loan.fromJson(x))),
    numOfLoans: List<Loan>.from(json["numOfLoans"].map((x) => Loan.fromJson(x))),
    anyLatePayments: json["anyLatePayments"],
    anyDefaults: json["anyDefaults"],
    numOfRejectedLoans: json["numOfRejectedLoans"],
    rejectedLoans: List<RejectedLoan>.from(json["rejectedLoans"].map((x) => RejectedLoan.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "activeLoans": List<dynamic>.from(activeLoans.map((x) => x.toJson())),
    "numOfLoans": List<dynamic>.from(numOfLoans.map((x) => x.toJson())),
    "anyLatePayments": anyLatePayments,
    "anyDefaults": anyDefaults,
    "numOfRejectedLoans": numOfRejectedLoans,
    "rejectedLoans": List<dynamic>.from(rejectedLoans.map((x) => x.toJson())),
  };
}

class Loan {
  Loan({
    this.loanStatus,
    this.isLoanApproved,
    this.fundsReceivedFromPartner,
    this.isFundReleased,
    this.loanRepaymentDetails,
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
    this.bankId,
    this.alfAmountDisburse,
    this.alfDateTime,
    this.alfTransferType,
    this.emiStartDate,
    this.fpAmountReceived,
    this.fpDateTime,
    this.fpFeesDeducted,
    this.refIdOfContract,
    this.lastModifiedBy,
    this.lastModifiedOn,
  });

  String loanStatus;
  bool isLoanApproved;
  bool fundsReceivedFromPartner;
  bool isFundReleased;
  List<dynamic> loanRepaymentDetails;
  bool isActive;
  DateTime createdOn;
  String id;
  int loanAmount;
  int emiAmount;
  double profit;
  int totalDue;
  double interestRate;
  int loanFees;
  int tenure;
  String productType;
  UserId userId;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String bankId;
  int alfAmountDisburse;
  DateTime alfDateTime;
  String alfTransferType;
  DateTime emiStartDate;
  int fpAmountReceived;
  DateTime fpDateTime;
  int fpFeesDeducted;
  String refIdOfContract;
  String lastModifiedBy;
  DateTime lastModifiedOn;

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
    loanStatus: json["loanStatus"],
    isLoanApproved: json["isLoanApproved"],
    fundsReceivedFromPartner: json["fundsReceivedFromPartner"],
    isFundReleased: json["isFundReleased"],
    loanRepaymentDetails: List<dynamic>.from(json["loanRepaymentDetails"].map((x) => x)),
    isActive: json["isActive"],
    createdOn: DateTime.parse(json["createdOn"]),
    id: json["_id"],
    loanAmount: json["loanAmount"],
    emiAmount: json["emiAmount"],
    profit: json["profit"].toDouble(),
    totalDue: json["totalDue"],
    interestRate: json["interestRate"].toDouble(),
    loanFees: json["loanFees"],
    tenure: json["tenure"],
    productType: json["productType"],
    userId: UserId.fromJson(json["userId"]),
    createdBy: json["createdBy"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    bankId: json["bankId"],
    alfAmountDisburse: json["alfAmountDisburse"],
    alfDateTime: DateTime.parse(json["alfDateTime"]),
    alfTransferType: json["alfTransferType"],
    emiStartDate: DateTime.parse(json["emiStartDate"]),
    fpAmountReceived: json["fpAmountReceived"],
    fpDateTime: DateTime.parse(json["fpDateTime"]),
    fpFeesDeducted: json["fpFeesDeducted"],
    refIdOfContract: json["refIdOfContract"],
    lastModifiedBy: json["lastModifiedBy"] == null ? null : json["lastModifiedBy"],
    lastModifiedOn: json["lastModifiedOn"] == null ? null : DateTime.parse(json["lastModifiedOn"]),
  );

  Map<String, dynamic> toJson() => {
    "loanStatus": loanStatus,
    "isLoanApproved": isLoanApproved,
    "fundsReceivedFromPartner": fundsReceivedFromPartner,
    "isFundReleased": isFundReleased,
    "loanRepaymentDetails": List<dynamic>.from(loanRepaymentDetails.map((x) => x)),
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
    "userId": userId.toJson(),
    "createdBy": createdBy,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "bankId": bankId,
    "alfAmountDisburse": alfAmountDisburse,
    "alfDateTime": alfDateTime.toIso8601String(),
    "alfTransferType": alfTransferType,
    "emiStartDate": emiStartDate.toIso8601String(),
    "fpAmountReceived": fpAmountReceived,
    "fpDateTime": fpDateTime.toIso8601String(),
    "fpFeesDeducted": fpFeesDeducted,
    "refIdOfContract": refIdOfContract,
    "lastModifiedBy": lastModifiedBy == null ? null : lastModifiedBy,
    "lastModifiedOn": lastModifiedOn == null ? null : lastModifiedOn.toIso8601String(),
  };
}



class UserId {
  UserId({
    this.countryCode,
    this.questionCovid,
    this.isActive,
    this.createdOn,
    this.id,
    this.role,
    this.mobile,
    this.password,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lastLoginDateTime,
    this.docSign,
    this.docEkyc,
    this.address1,
    this.address2,
    this.city,
    this.dob,
    this.educationLevel,
    this.email,
    this.employmentStatus,
    this.facebookId,
    this.firstName,
    this.gender,
    this.icNumber,
    this.lastName,
    this.maritalStatus,
    this.numOfChild,
    this.zipCode,
    this.docPhoto,
    this.isBorrower,
  });

  int countryCode;
  QuestionCovid questionCovid;
  bool isActive;
  DateTime createdOn;
  String id;
  String role;
  int mobile;
  String password;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  DateTime lastLoginDateTime;
  String docSign;
  String docEkyc;
  String address1;
  String address2;
  String city;
  DateTime dob;
  String educationLevel;
  String email;
  String employmentStatus;
  String facebookId;
  String firstName;
  String gender;
  String icNumber;
  String lastName;
  String maritalStatus;
  int numOfChild;
  String zipCode;
  String docPhoto;
  bool isBorrower;

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
    countryCode: json["countryCode"],
    questionCovid: QuestionCovid.fromJson(json["questionCovid"]),
    isActive: json["isActive"],
    createdOn: DateTime.parse(json["createdOn"]),
    id: json["_id"],
    role: json["role"],
    mobile: json["mobile"],
    password: json["password"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    lastLoginDateTime: DateTime.parse(json["lastLoginDateTime"]),
    docSign: json["docSign"],
    docEkyc: json["docEKYC"],
    address1: json["address1"],
    address2: json["address2"],
    city: json["city"],
    dob: DateTime.parse(json["dob"]),
    educationLevel: json["educationLevel"],
    email: json["email"],
    employmentStatus: json["employmentStatus"],
    facebookId: json["facebookId"],
    firstName: json["firstName"],
    gender: json["gender"],
    icNumber: json["icNumber"],
    lastName: json["lastName"],
    maritalStatus: json["maritalStatus"],
    numOfChild: json["numOfChild"],
    zipCode: json["zipCode"],
    docPhoto: json["docPhoto"],
    isBorrower: json["isBorrower"],
  );

  Map<String, dynamic> toJson() => {
    "countryCode": countryCode,
    "questionCovid": questionCovid.toJson(),
    "isActive": isActive,
    "createdOn": createdOn.toIso8601String(),
    "_id": id,
    "role": role,
    "mobile": mobile,
    "password": password,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "lastLoginDateTime": lastLoginDateTime.toIso8601String(),
    "docSign": docSign,
    "docEKYC": docEkyc,
    "address1": address1,
    "address2": address2,
    "city": city,
    "dob": dob.toIso8601String(),
    "educationLevel": educationLevel,
    "email": email,
    "employmentStatus": employmentStatus,
    "facebookId": facebookId,
    "firstName": firstName,
    "gender": gender,
    "icNumber": icNumber,
    "lastName": lastName,
    "maritalStatus": maritalStatus,
    "numOfChild": numOfChild,
    "zipCode": zipCode,
    "docPhoto": docPhoto,
    "isBorrower": isBorrower,
  };
}

class QuestionCovid {
  QuestionCovid({
    this.incomeLoss,
    this.familyLoss,
    this.healthImpact,
    this.safer,
  });

  bool incomeLoss;
  bool familyLoss;
  bool healthImpact;
  bool safer;

  factory QuestionCovid.fromJson(Map<String, dynamic> json) => QuestionCovid(
    incomeLoss: json["incomeLoss"],
    familyLoss: json["familyLoss"],
    healthImpact: json["healthImpact"],
    safer: json["safer"],
  );

  Map<String, dynamic> toJson() => {
    "incomeLoss": incomeLoss,
    "familyLoss": familyLoss,
    "healthImpact": healthImpact,
    "safer": safer,
  };
}

class RejectedLoan {
  RejectedLoan({
    this.loanStatus,
    this.isLoanApproved,
    this.fundsReceivedFromPartner,
    this.isFundReleased,
    this.loanRepaymentDetails,
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
    this.bankId,
    this.lastModifiedBy,
    this.lastModifiedOn,
    this.loanApproveOrRejectedDate,
    this.loanApprovedOrRejectedBy,
    this.remarks,
  });

  LoanStatusEnum loanStatus;
  bool isLoanApproved;
  bool fundsReceivedFromPartner;
  bool isFundReleased;
  List<dynamic> loanRepaymentDetails;
  bool isActive;
  DateTime createdOn;
  String id;
  int loanAmount;
  int emiAmount;
  double profit;
  int totalDue;
  double interestRate;
  int loanFees;
  int tenure;
  String productType;
  CreatedBy userId;
  CreatedBy createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String bankId;
  String lastModifiedBy;
  DateTime lastModifiedOn;
  DateTime loanApproveOrRejectedDate;
  String loanApprovedOrRejectedBy;
  String remarks;

  factory RejectedLoan.fromJson(Map<String, dynamic> json) => RejectedLoan(
    loanStatus: loanStatusEnumValues.map[json["loanStatus"]],
    isLoanApproved: json["isLoanApproved"],
    fundsReceivedFromPartner: json["fundsReceivedFromPartner"],
    isFundReleased: json["isFundReleased"],
    loanRepaymentDetails: List<dynamic>.from(json["loanRepaymentDetails"].map((x) => x)),
    isActive: json["isActive"],
    createdOn: DateTime.parse(json["createdOn"]),
    id: json["_id"],
    loanAmount: json["loanAmount"],
    emiAmount: json["emiAmount"],
    profit: json["profit"].toDouble(),
    totalDue: json["totalDue"],
    interestRate: json["interestRate"].toDouble(),
    loanFees: json["loanFees"],
    tenure: json["tenure"],
    productType: json["productType"],
    userId: createdByValues.map[json["userId"]],
    createdBy: createdByValues.map[json["createdBy"]],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    bankId: json["bankId"] == null ? null : json["bankId"],
    lastModifiedBy: json["lastModifiedBy"] == null ? null : json["lastModifiedBy"],
    lastModifiedOn: json["lastModifiedOn"] == null ? null : DateTime.parse(json["lastModifiedOn"]),
    loanApproveOrRejectedDate: json["loanApproveOrRejectedDate"] == null ? null : DateTime.parse(json["loanApproveOrRejectedDate"]),
    loanApprovedOrRejectedBy: json["loanApprovedOrRejectedBy"] == null ? null : json["loanApprovedOrRejectedBy"],
    remarks: json["remarks"] == null ? null : json["remarks"],
  );

  Map<String, dynamic> toJson() => {
    "loanStatus": loanStatusEnumValues.reverse[loanStatus],
    "isLoanApproved": isLoanApproved,
    "fundsReceivedFromPartner": fundsReceivedFromPartner,
    "isFundReleased": isFundReleased,
    "loanRepaymentDetails": List<dynamic>.from(loanRepaymentDetails.map((x) => x)),
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
    "userId": createdByValues.reverse[userId],
    "createdBy": createdByValues.reverse[createdBy],
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "bankId": bankId == null ? null : bankId,
    "lastModifiedBy": lastModifiedBy == null ? null : lastModifiedBy,
    "lastModifiedOn": lastModifiedOn == null ? null : lastModifiedOn.toIso8601String(),
    "loanApproveOrRejectedDate": loanApproveOrRejectedDate == null ? null : loanApproveOrRejectedDate.toIso8601String(),
    "loanApprovedOrRejectedBy": loanApprovedOrRejectedBy == null ? null : loanApprovedOrRejectedBy,
    "remarks": remarks == null ? null : remarks,
  };
}

enum CreatedBy { THE_6126494_FE27_D6181811_BF6_C3, THE_61458484_BE2_E975_D7416_D582, THE_612_BAA50309_A1_D2996232_BDB }

final createdByValues = EnumValues({
  "6126494fe27d6181811bf6c3": CreatedBy.THE_6126494_FE27_D6181811_BF6_C3,
  "612baa50309a1d2996232bdb": CreatedBy.THE_612_BAA50309_A1_D2996232_BDB,
  "61458484be2e975d7416d582": CreatedBy.THE_61458484_BE2_E975_D7416_D582
});

enum LoanStatusEnum { REJECTED }

final loanStatusEnumValues = EnumValues({
  "Rejected": LoanStatusEnum.REJECTED
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
