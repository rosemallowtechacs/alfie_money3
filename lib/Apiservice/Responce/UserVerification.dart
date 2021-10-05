
class UserVerification {
  UserVerification({
    this.result,
    this.status,
  });

  String result;
  bool status;

   UserVerification.fromJson(Map<String, dynamic> json)  {
     result= json["result"];
     status= json["status"];
   }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['status'] = this.status;
    return data;
  }
}