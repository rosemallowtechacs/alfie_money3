
import 'package:creditscore/Apiservice/Responce/ProfiledetailsResponce.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  Future<bool> saveUser(Profiledetails user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final DateFormat formatter = DateFormat('MM-dd-yyyy');
    prefs.setInt('mobileNumber',user.mobile);
    prefs.setString('password',user.password);
    prefs.setString('profilePic',user.docPhoto);
    prefs.setString('firstName',user.firstName);
    prefs.setString('lastName',user.lastName);
    prefs.setString('icNumber',user.icNumber);

    prefs.setString('address1',user.address1);
    prefs.setString('address2',user.address2);
    prefs.setString('dob',formatter.format(DateTime.parse(user.dob)));
    prefs.setString('cityName',user.city);
    prefs.setString('zipcode',user.zipCode);
    prefs.setString('emailId',user.email);

    prefs.setString('fbId',user.facebookId);
    prefs.setInt('childCount',user.numofchild);
    prefs.setString('employment',user.employment);
    prefs.setString('education',user.education);
    prefs.setString('maritalStatus',user.maritalstatus);
    prefs.setString('gender',user.gender);
    prefs.setString('age',calculateAge(DateTime.parse(user.dob)));

    return prefs.commit();

  }

  Future<Profiledetails> getUser ()  async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();

   int mobileNumber = prefs.getInt("mobileNumber");
   String password = prefs.getString("password");
   String profilePic = prefs.getString("profilePic");
   String firstName = prefs.getString("firstName");
   String lastName = prefs.getString("lastName");
   String icNumber = prefs.getString("icNumber");
   String address1 = prefs.getString("address1");

   String address2 = prefs.getString("address2");
   String dob = prefs.getString("dob");
   int childCount = prefs.getInt("childCount");
   String employment = prefs.getString("employment");
   String education = prefs.getString("education");
   String maritalStatus = prefs.getString("maritalStatus");
   String gender = prefs.getString("gender");
   String age = prefs.getString("age");

   return Profiledetails(mobile: mobileNumber,password: password,docPhoto: profilePic,
   firstName: firstName,lastName: lastName,icNumber: icNumber,address1: address1,
   address2: address2,dob: dob,numofchild: childCount,employment: employment,education: education,
   maritalstatus: maritalStatus,gender: gender);

  }

  void removeUser() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('mobileNumber');
    prefs.remove('password');
    prefs.remove('profilePic');
    prefs.remove('firstName');
    prefs.remove('lastName');
    prefs.remove('icNumber');

    prefs.remove('address1');
    prefs.remove('address2');
    prefs.remove('dob');
    prefs.remove('childCount');
    prefs.remove('employment');
    prefs.remove('education');

    prefs.remove('maritalStatus');
    prefs.remove('gender');
    prefs.remove('age');

  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }

}