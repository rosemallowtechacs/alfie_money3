import 'dart:convert';

import 'package:creditscore/Common/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'Responce/ProfiledetailsResponce.dart';
class APIS {

  static const  baseurl="http://104.131.5.210:7400";
  static const  terms = baseurl+"/api/users/terms";
  static const  register = baseurl+"/api/users/exist";
  static const  register_user = baseurl+"/api/users";
  static const  forgot = baseurl+"/api/users/forgotPassword";
  static const  changePassword = baseurl+"/api/users/changePassword";
  static const  login = baseurl+"/api/users/login";
  static const  fileupload = baseurl+"/api/users/doc/";
  static const  getuser = baseurl+"/api/users/";
  static const  profiledata = baseurl+"/api/users/";
  static const  download = baseurl+"/api/users/doc/";
  static const  applyloan = baseurl+"/api/loans";
  static const  bankDetails = baseurl+"/api/loans/";
  static const  bankDocuments = baseurl+"/api/loans/doc/";
  static const  covidQuestions = baseurl+"/api/users/question/";
  static const  repayment = baseurl+"/api/repayments";
  static const  dashboardDetails = baseurl+"/api/loans/dashboard";
  static const  availedLoan = baseurl+"/api/loans/availed";
  static const  availedLoanDetails = baseurl+"/api/loans/";
  static const  disposementLoan = baseurl+"/api/loans/mydisbursed?userId=";
  ///////
  static const  AddBankDetails = baseurl+"/api/bankdetails";
  static const  ViewBankDetails = baseurl+"/api/bankdetails/my";
  static const  AddBankDocument = baseurl+"/api/bankdetails/doc/";
  static const  AddBankLoan = baseurl+"/api/loans/";

  static const  LaondetalsApi = baseurl+"/api/loans/borrowerprofile?borrowerId=";

  /*http://104.131.5.210:7400/api/loans/borrowerprofile?borrowerId=61446290be2e975d7416b55c*/




  static const NoAuths = [
    terms,
    register,
    forgot,
    login,
    register_user
  ];



  static Future<Profiledetails> updateProfile(String token,String userId,String username,String lastname,String icnumber,String dob,String address1,String address2,String city,String zipcode,String emailid, String facebookid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //String userId=preferences.getString(Constants.userId);
   // String token=preferences.getString(Constants.token);
    print(token);
    final response = await http.put(
      Uri.parse(APIS.profiledata+userId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization":token,
      },
      body: jsonEncode(<String, String>{
        'firstName':username,
        'lastName':lastname,
        'icNumber':icnumber,
        'dob':dob,
        'address1':address1,
        'address2':address2,
        'city':city,
        'zipCode':zipcode,
        'email':emailid,
        'facebookId':facebookid
      }),
    );
    if (response.statusCode == 200) {
      print(response.body);
      return Profiledetails.fromJson(jsonDecode(response.body));

    } else {

      throw Exception('Failed to update profile');
    }
  }

}

//api/users/doc/d51708f0-0572-11ec-b4e0-15617ff50f8c.png?key=docSign