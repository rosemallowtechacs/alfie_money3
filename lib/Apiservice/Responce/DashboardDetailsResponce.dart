// To parse this JSON data, do
//
//     final getDashboardDetails = getDashboardDetailsFromJson(jsonString);

import 'dart:convert';

GetDashboardDetails getDashboardDetailsFromJson(String str) => GetDashboardDetails.fromJson(json.decode(str));

String getDashboardDetailsToJson(GetDashboardDetails data) => json.encode(data.toJson());

class GetDashboardDetails {
  GetDashboardDetails({
    this.totalApplications,
    this.approvedPercentage,
    this.amountApproved,
    this.byAcsScore,
    this.byValueOfLoan,
    this.byGender,
    this.byLocation,
    this.byAgeGroup,
    this.totalLoanDisbursedDaily,
    this.totalLoanDisbursedMonthly,
    this.totalLoanDisbursedQuarterly,
    this.totalLoanDisbursedYtd,
    this.totalLoanOutstandingDaily,
    this.totalLoanOutstandingMonthly,
    this.totalLoanOutstandingQuarterly,
    this.totalLoanOutstandingYtd,
    this.active,
    this.onTimeEmiRepaid,
    this.latePayment,
    this.dpd30,
    this.dpd60,
    this.dpd90,
  });

  int totalApplications;
  double approvedPercentage;
  int amountApproved;
  String byAcsScore;
  int byValueOfLoan;
  List<ByGender> byGender;
  List<ByLocation> byLocation;
  List<ByAgeGroup> byAgeGroup;
  TotalLoanDisbursed totalLoanDisbursedDaily;
  TotalLoanDisbursed totalLoanDisbursedMonthly;
  TotalLoanDisbursed totalLoanDisbursedQuarterly;
  TotalLoanDisbursed totalLoanDisbursedYtd;
  TotalLoanOutstanding totalLoanOutstandingDaily;
  TotalLoanOutstanding totalLoanOutstandingMonthly;
  TotalLoanOutstanding totalLoanOutstandingQuarterly;
  TotalLoanOutstanding totalLoanOutstandingYtd;
  int active;
  int onTimeEmiRepaid;
  Dpd30 latePayment;
  Dpd30 dpd30;
  Dpd30 dpd60;
  Dpd30 dpd90;

  factory GetDashboardDetails.fromJson(Map<String, dynamic> json) => GetDashboardDetails(
    totalApplications: json["totalApplications"],
    approvedPercentage: json["approvedPercentage"].toDouble(),
    amountApproved: json["amountApproved"],
    byAcsScore: json["byAcsScore"],
    byValueOfLoan: json["byValueOfLoan"],
    byGender: List<ByGender>.from(json["byGender"].map((x) => ByGender.fromJson(x))),
    byLocation: List<ByLocation>.from(json["byLocation"].map((x) => ByLocation.fromJson(x))),
    byAgeGroup: List<ByAgeGroup>.from(json["byAgeGroup"].map((x) => ByAgeGroup.fromJson(x))),
    totalLoanDisbursedDaily: TotalLoanDisbursed.fromJson(json["totalLoanDisbursedDaily"]),
    totalLoanDisbursedMonthly: TotalLoanDisbursed.fromJson(json["totalLoanDisbursedMonthly"]),
    totalLoanDisbursedQuarterly: TotalLoanDisbursed.fromJson(json["totalLoanDisbursedQuarterly"]),
    totalLoanDisbursedYtd: TotalLoanDisbursed.fromJson(json["totalLoanDisbursedYTD"]),
    totalLoanOutstandingDaily: TotalLoanOutstanding.fromJson(json["totalLoanOutstandingDaily"]),
    totalLoanOutstandingMonthly: TotalLoanOutstanding.fromJson(json["totalLoanOutstandingMonthly"]),
    totalLoanOutstandingQuarterly: TotalLoanOutstanding.fromJson(json["totalLoanOutstandingQuarterly"]),
    totalLoanOutstandingYtd: TotalLoanOutstanding.fromJson(json["totalLoanOutstandingYTD"]),
    active: json["active"],
    onTimeEmiRepaid: json["onTimeEMIRepaid"],
    latePayment: Dpd30.fromJson(json["latePayment"]),
    dpd30: Dpd30.fromJson(json["dpd30"]),
    dpd60: Dpd30.fromJson(json["dpd60"]),
    dpd90: Dpd30.fromJson(json["dpd90"]),
  );

  Map<String, dynamic> toJson() => {
    "totalApplications": totalApplications,
    "approvedPercentage": approvedPercentage,
    "amountApproved": amountApproved,
    "byAcsScore": byAcsScore,
    "byValueOfLoan": byValueOfLoan,
    "byGender": List<dynamic>.from(byGender.map((x) => x.toJson())),
    "byLocation": List<dynamic>.from(byLocation.map((x) => x.toJson())),
    "byAgeGroup": List<dynamic>.from(byAgeGroup.map((x) => x.toJson())),
    "totalLoanDisbursedDaily": totalLoanDisbursedDaily.toJson(),
    "totalLoanDisbursedMonthly": totalLoanDisbursedMonthly.toJson(),
    "totalLoanDisbursedQuarterly": totalLoanDisbursedQuarterly.toJson(),
    "totalLoanDisbursedYTD": totalLoanDisbursedYtd.toJson(),
    "totalLoanOutstandingDaily": totalLoanOutstandingDaily.toJson(),
    "totalLoanOutstandingMonthly": totalLoanOutstandingMonthly.toJson(),
    "totalLoanOutstandingQuarterly": totalLoanOutstandingQuarterly.toJson(),
    "totalLoanOutstandingYTD": totalLoanOutstandingYtd.toJson(),
    "active": active,
    "onTimeEMIRepaid": onTimeEmiRepaid,
    "latePayment": latePayment.toJson(),
    "dpd30": dpd30.toJson(),
    "dpd60": dpd60.toJson(),
    "dpd90": dpd90.toJson(),
  };
}

class ByAgeGroup {
  ByAgeGroup({
    this.group,
    this.count,
    this.data,
  });

  String group;
  int count;
  List<ByAgeGroupDatum> data;

  factory ByAgeGroup.fromJson(Map<String, dynamic> json) => ByAgeGroup(
    group: json["group"],
    count: json["count"],
    data: List<ByAgeGroupDatum>.from(json["data"].map((x) => ByAgeGroupDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "group": group,
    "count": count,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ByAgeGroupDatum {
  ByAgeGroupDatum({
    this.countryCode,
    this.questionCovid,
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
    this.resetPasswordExpires,
    this.resetPasswordToken,
    this.address1,
    this.address2,
    this.city,
    this.dob,
    this.educationLevel,
    this.email,
    this.employmentStatus,
    this.facebookId,
    this.firstName,
    this.icNumber,
    this.lastName,
    this.maritalStatus,
    this.numOfChild,
    this.zipCode,
    this.gender,
    this.docPhoto,
    this.lastLoginDateTime,
  });

  int countryCode;
  QuestionCovid questionCovid;
  String role;
  bool isActive;
  DateTime createdOn;
  CreatedBy id;
  int mobile;
  String password;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String docSign;
  String docEkyc;
  DateTime resetPasswordExpires;
  String resetPasswordToken;
  String address1;
  String address2;
  String city;
  DateTime dob;
  String educationLevel;
  String email;
  String employmentStatus;
  String facebookId;
  String firstName;
  String icNumber;
  String lastName;
  String maritalStatus;
  int numOfChild;
  String zipCode;
  String gender;
  String docPhoto;
  DateTime lastLoginDateTime;

  factory ByAgeGroupDatum.fromJson(Map<String, dynamic> json) => ByAgeGroupDatum(
    countryCode: json["countryCode"],
    questionCovid: QuestionCovid.fromJson(json["questionCovid"]),
    role: json["role"],
    isActive: json["isActive"],
    createdOn: DateTime.parse(json["createdOn"]),
    id: createdByValues.map[json["_id"]],
    mobile: json["mobile"],
    password: json["password"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    docSign: json["docSign"],
    docEkyc: json["docEKYC"],
    resetPasswordExpires: json["resetPasswordExpires"] == null ? null : DateTime.parse(json["resetPasswordExpires"]),
    resetPasswordToken: json["resetPasswordToken"] == null ? null : json["resetPasswordToken"],
    address1: json["address1"],
    address2: json["address2"],
    city: json["city"],
    dob: DateTime.parse(json["dob"]),
    educationLevel: json["educationLevel"] == null ? null : json["educationLevel"],
    email: json["email"],
    employmentStatus: json["employmentStatus"] == null ? null : json["employmentStatus"],
    facebookId: json["facebookId"],
    firstName: json["firstName"],
    icNumber: json["icNumber"],
    lastName: json["lastName"],
    maritalStatus: json["maritalStatus"] == null ? null : json["maritalStatus"],
    numOfChild: json["numOfChild"] == null ? null : json["numOfChild"],
    zipCode: json["zipCode"],
    gender: json["gender"] == null ? null : json["gender"],
    docPhoto: json["docPhoto"] == null ? null : json["docPhoto"],
    lastLoginDateTime: DateTime.parse(json["lastLoginDateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "countryCode": countryCode,
    "questionCovid": questionCovid.toJson(),
    "role": role,
    "isActive": isActive,
    "createdOn": createdOn.toIso8601String(),
    "_id": createdByValues.reverse[id],
    "mobile": mobile,
    "password": password,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "docSign": docSign,
    "docEKYC": docEkyc,
    "resetPasswordExpires": resetPasswordExpires == null ? null : resetPasswordExpires.toIso8601String(),
    "resetPasswordToken": resetPasswordToken == null ? null : resetPasswordToken,
    "address1": address1,
    "address2": address2,
    "city": city,
    "dob": dob.toIso8601String(),
    "educationLevel": educationLevel == null ? null : educationLevel,
    "email": email,
    "employmentStatus": employmentStatus == null ? null : employmentStatus,
    "facebookId": facebookId,
    "firstName": firstName,
    "icNumber": icNumber,
    "lastName": lastName,
    "maritalStatus": maritalStatus == null ? null : maritalStatus,
    "numOfChild": numOfChild == null ? null : numOfChild,
    "zipCode": zipCode,
    "gender": gender == null ? null : gender,
    "docPhoto": docPhoto == null ? null : docPhoto,
    "lastLoginDateTime": lastLoginDateTime.toIso8601String(),
  };
}

enum CreatedBy { THE_612_CBDF9082_FF998_F1_B5_F781, THE_6126494_FE27_D6181811_BF6_C3, THE_6130_C785_E1_A420_ADFDDE1_B34 }

final createdByValues = EnumValues({
  "6126494fe27d6181811bf6c3": CreatedBy.THE_6126494_FE27_D6181811_BF6_C3,
  "612cbdf9082ff998f1b5f781": CreatedBy.THE_612_CBDF9082_FF998_F1_B5_F781,
  "6130c785e1a420adfdde1b34": CreatedBy.THE_6130_C785_E1_A420_ADFDDE1_B34
});

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

class ByGender {
  ByGender({
    this.count,
    this.gender,
    this.data,
  });

  int count;
  String gender;
  List<ByAgeGroupDatum> data;

  factory ByGender.fromJson(Map<String, dynamic> json) => ByGender(
    count: json["count"],
    gender: json["gender"],
    data: List<ByAgeGroupDatum>.from(json["data"].map((x) => ByAgeGroupDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "gender": gender,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ByLocation {
  ByLocation({
    this.cityName,
    this.count,
    this.data,
  });

  String cityName;
  int count;
  List<ByAgeGroupDatum> data;

  factory ByLocation.fromJson(Map<String, dynamic> json) => ByLocation(
    cityName: json["cityName"],
    count: json["count"],
    data: List<ByAgeGroupDatum>.from(json["data"].map((x) => ByAgeGroupDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cityName": cityName,
    "count": count,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Dpd30 {
  Dpd30({
    this.count,
    this.data,
  });

  int count;
  List<dynamic> data;

  factory Dpd30.fromJson(Map<String, dynamic> json) => Dpd30(
    count: json["count"],
    data: List<dynamic>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}

class TotalLoanDisbursed {
  TotalLoanDisbursed({
    this.data,
    this.counts,
  });

  List<TotalLoanDisbursedDailyDatum> data;
  int counts;

  factory TotalLoanDisbursed.fromJson(Map<String, dynamic> json) => TotalLoanDisbursed(
    data: List<TotalLoanDisbursedDailyDatum>.from(json["data"].map((x) => TotalLoanDisbursedDailyDatum.fromJson(x))),
    counts: json["counts"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "counts": counts,
  };
}

class TotalLoanDisbursedDailyDatum {
  TotalLoanDisbursedDailyDatum({
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
  ProductType productType;
  CreatedBy userId;
  CreatedBy createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  int alfAmountDisburse;
  DateTime alfDateTime;
  String alfTransferType;
  DateTime emiStartDate;
  int fpAmountReceived;
  DateTime fpDateTime;
  int fpFeesDeducted;
  String refIdOfContract;
  String remarks;

  factory TotalLoanDisbursedDailyDatum.fromJson(Map<String, dynamic> json) => TotalLoanDisbursedDailyDatum(
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
    productType: productTypeValues.map[json["productType"]],
    userId: createdByValues.map[json["userId"]],
    createdBy: createdByValues.map[json["createdBy"]],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    alfAmountDisburse: json["alfAmountDisburse"],
    alfDateTime: DateTime.parse(json["alfDateTime"]),
    alfTransferType: json["alfTransferType"],
    emiStartDate: DateTime.parse(json["emiStartDate"]),
    fpAmountReceived: json["fpAmountReceived"],
    fpDateTime: json["fpDateTime"] == null ? null : DateTime.parse(json["fpDateTime"]),
    fpFeesDeducted: json["fpFeesDeducted"],
    refIdOfContract: json["refIdOfContract"],
    remarks: json["remarks"] == null ? null : json["remarks"],
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
    "productType": productTypeValues.reverse[productType],
    "userId": createdByValues.reverse[userId],
    "createdBy": createdByValues.reverse[createdBy],
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "alfAmountDisburse": alfAmountDisburse,
    "alfDateTime": alfDateTime.toIso8601String(),
    "alfTransferType": alfTransferType,
    "emiStartDate": emiStartDate.toIso8601String(),
    "fpAmountReceived": fpAmountReceived,
    "fpDateTime": fpDateTime == null ? null : fpDateTime.toIso8601String(),
    "fpFeesDeducted": fpFeesDeducted,
    "refIdOfContract": refIdOfContract,
    "remarks": remarks == null ? null : remarks,
  };
}

enum ProductType { BNPL }

final productTypeValues = EnumValues({
  "BNPL": ProductType.BNPL
});

class TotalLoanOutstanding {
  TotalLoanOutstanding({
    this.data,
    this.counts,
  });

  List<TotalLoanOutstandingDailyDatum> data;
  int counts;

  factory TotalLoanOutstanding.fromJson(Map<String, dynamic> json) => TotalLoanOutstanding(
    data: List<TotalLoanOutstandingDailyDatum>.from(json["data"].map((x) => TotalLoanOutstandingDailyDatum.fromJson(x))),
    counts: json["counts"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "counts": counts,
  };
}

class TotalLoanOutstandingDailyDatum {
  TotalLoanOutstandingDailyDatum({
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
    this.docBankStatements,
  });

  LoanStatus loanStatus;
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
  ProductType productType;
  CreatedBy userId;
  CreatedBy createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String docBankStatements;

  factory TotalLoanOutstandingDailyDatum.fromJson(Map<String, dynamic> json) => TotalLoanOutstandingDailyDatum(
    loanStatus: loanStatusValues.map[json["loanStatus"]],
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
    productType: productTypeValues.map[json["productType"]],
    userId: createdByValues.map[json["userId"]],
    createdBy: createdByValues.map[json["createdBy"]],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    docBankStatements: json["docBankStatements"] == null ? null : json["docBankStatements"],
  );

  Map<String, dynamic> toJson() => {
    "loanStatus": loanStatusValues.reverse[loanStatus],
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
    "productType": productTypeValues.reverse[productType],
    "userId": createdByValues.reverse[userId],
    "createdBy": createdByValues.reverse[createdBy],
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "docBankStatements": docBankStatements == null ? null : docBankStatements,
  };
}

enum LoanStatus { LOAN_APPROVAL_PENDING }

final loanStatusValues = EnumValues({
  "Loan approval pending": LoanStatus.LOAN_APPROVAL_PENDING
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
