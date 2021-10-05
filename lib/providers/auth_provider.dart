import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Apiservice/Responce/LoanDetails.dart';
import 'package:creditscore/Apiservice/Responce/ProfiledetailsResponce.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:creditscore/Data/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider extends ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;

  set loggedInStatus(Status value) {
    _loggedInStatus = value;
  }

  Status get registeredInStatus => _registeredInStatus;

  set registeredInStatus(Status value) {
    _registeredInStatus = value;
  }


  Future<Map<String, dynamic>> getProfile() async {

    var result;
    String userId = await PreferenceManager.sharedInstance.getString(
        Keys.USER_ID.toString());
    String token = await PreferenceManager.sharedInstance.getString(
        Keys.ACCESS_TOKEN.toString());

    notifyListeners();

    Response  response = await get(Uri.parse(APIS.getuser + userId), headers: {
      "Authorization": token,
    },);

    if (response.statusCode == 200) {

      final Map<String, dynamic> responseData = json.decode(response.body);

      print(responseData);

      var userData = responseData['Content'];
      String data = response.body;
      var decodedData = jsonDecode(data);
      Profiledetails registrationResponse = Profiledetails.fromJson(decodedData);

      UserPreferences().saveUser(registrationResponse);

      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': registrationResponse};

    } else {

      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }

    return result;

  }


  static onError(error){
    print('the error is ${error.detail}');
    return {
      'status':false,
      'message':'Unsuccessful Request',
      'data':error
    };
  }



  Future<LoanDetails> getloandetils_get(context) async {
    LoanDetails result;
    String token = await PreferenceManager.sharedInstance
        .getString(Keys.ACCESS_TOKEN.toString());
    String userId = await PreferenceManager.sharedInstance
        .getString(Keys.USER_ID.toString());
    var response = await http.get(Uri.parse(APIS.LaondetalsApi+userId),headers: {
      'Authorization':token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        print(data);
        /*String data = response.body;

        var decodedData = jsonDecode(data);
        GetDashboardDetails registrationResponse = GetDashboardDetails.fromJson(decodedData);

        print(registrationResponse.amountApproved);*/
        final item = json.decode(response.body);
        result = LoanDetails.fromJson(item);

      }
    } catch (e) {
      throw Exception('Failed to load ');
    }

    return result;
  }
}
