


class Loginmodel {
  final String countryCode;
  final int role;
  final bool isActive;
  final String createdOn;
  final String id;
final String mobile;
final String password;
final String createdAt;
final String updatedAt;
final String version;


  const Loginmodel({
     this.countryCode,
     this.role,
     this.isActive,
     this.createdOn,
     this.id,
     this.mobile,
     this.password,
     this.createdAt,
     this.updatedAt,
     this.version,
  });

  factory Loginmodel.fromJson(Map<String, dynamic> json) {
    return Loginmodel(
    countryCode: json['countryCode'] as String,
     role: json['role'] as int,
   isActive: json['isActive'] as bool,
    createdOn: json['createdOn'] as String,
     id: json['_id'] as String,
    mobile: json['mobile'] as String,
   password: json['password'] as String,
createdAt: json['createdAt'] as String,
updatedAt: json['updatedAt'] as String,
version: json['__v'] as String,
    );
  }
}