
import 'dart:convert';
import 'dart:io';
import 'package:creditscore/Apiservice/DioUtils.dart';
import 'package:creditscore/Apiservice/Responce/ProfiledetailsResponce.dart';
import 'package:creditscore/Apiservice/Responce/UserVerification.dart';
import 'package:creditscore/Apiservice/base/BaseApiResponse.dart';
import 'package:creditscore/Apiservice/base/BasePresenter.dart';
import 'package:creditscore/Apiservice/base/BaseView.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:creditscore/Apiservice/base/BaseApiResponse.dart' as api;
import 'package:creditscore/Apiservice/base/BasePresenter.dart';
import 'package:creditscore/Apiservice/base/BaseView.dart';
import 'package:creditscore/Apiservice/DioUtils.dart';
import 'package:creditscore/Apiservice/Responce/RegisterResponce.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../KYCimage.dart';
import '../OtpScreen.dart';

class UserprofileView extends BaseView {
  void submitBtnDidTapped() {}

  void registrationDidSucceed() {}
  void profileDidReceived(Profiledetails profiledetails ) {}
  void submitBtnFileUpload() {}
  void registrationDidFailed(String invalidFields) {}

}

class UserProfilePresenter {
  void doRegistration(BuildContext context,var registrationData) {}
  void doFileUpload(File file){
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////
class UserProfilePresenterImpl extends BasePresenter<UserprofileView>
    implements UserProfilePresenter {
   UserProfilePresenterImpl(UserprofileView view) : super(view);


  String verificationId, smsCode;
  bool codeSent = false;
  @override
  void doRegistration(BuildContext context, var registrationData) async {
    String userid=await PreferenceManager.sharedInstance.getString(Keys.USER_ID.toString());
    String  token=await PreferenceManager.sharedInstance.getString(Keys.ACCESS_TOKEN.toString());
    mView.onNetworkCallStarted("Loading...");
    print(registrationData);
    var response = await http.put(Uri.parse(APIS.profiledata+userid), headers: {
      "Content-type": "application/json",
      "Authorization": token}, body: json.encode(registrationData));

    if (response.statusCode == 200) {

      var responseJSON = json.decode(response.body);
      Profiledetails  registerusers_responce = Profiledetails.fromJson(responseJSON);
      Provider.of<UserProvider>(context, listen: false).setUser(registerusers_responce);
      print("rameshstart");
      print(responseJSON);



      Fluttertoast.showToast(
          msg:"Update Successful" ,
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Rmlightblue,
          textColor: Colors.white,
          fontSize: 16.0);
      mView.onNetworkCallEnded();
      mView.registrationDidSucceed();
      return responseJSON;
    }else if (response.statusCode == 401) {
      print('ramesh' + response.body);

      mView.onNetworkCallEnded();
        var responseJSON = json.decode(response.body);
        String message = responseJSON["msg"];

        Fluttertoast.showToast(
            msg: message,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);


    }else {
      throw Exception('Failed to load post');
    }

  }

  @override
  void getUserData() async {
    String token = await PreferenceManager.sharedInstance
        .getString(Keys.ACCESS_TOKEN.toString());
    String userId=await PreferenceManager.sharedInstance.getString(Keys.USER_ID.toString());
    var response= await http.get(Uri.parse(APIS.getuser+userId),headers: {
      "Authorization":token,
    },);

      if (response.statusCode == 200) {
        print('ramesh' + response.body);
        var responseJSON = json.decode(response.body);
        Profiledetails registrationResponse = Profiledetails.fromJson(responseJSON);
        print(registrationResponse.docSign);
        Map<String, dynamic> map = Map();
        map[ProfileKeys.FIRSTNAME_.toString()] = registrationResponse.firstName;
        map[ProfileKeys.LASTNAME_.toString()] = registrationResponse.lastName;
        map[ProfileKeys.ICNUM_.toString()] = registrationResponse.icNumber;
        map[ProfileKeys.ZIPCODE_.toString()] = registrationResponse.zipCode;
        map[ProfileKeys.MOBILE_.toString()] = registrationResponse.mobile;
        map[ProfileKeys.EMAIL_.toString()] = registrationResponse.email;
        map[ProfileKeys.DOB_.toString()] = registrationResponse.dob;
        map[ProfileKeys.CITY_.toString()] = registrationResponse.city;
        map[ProfileKeys.ADDRESS1_.toString()] = registrationResponse.address1;
        map[ProfileKeys.ADDRESS2_.toString()] = registrationResponse.address2;
        map[ProfileKeys.FACEBOOK_.toString()] = registrationResponse.facebookId;
        map[ProfileKeys.EMPLOYMENT_.toString()] = registrationResponse.employment;
        map[ProfileKeys.EDUCATION_.toString()] = registrationResponse.education;
        map[ProfileKeys.MARITALSTATUS_.toString()] = registrationResponse.maritalstatus;
        map[ProfileKeys.NUM_CHILD_.toString()] = registrationResponse.numofchild;
        map[ProfileKeys.GENDER_.toString()] = registrationResponse.gender;
        map[ProfileKeys.PROFILE_PIC.toString()] = registrationResponse.docPhoto;
        await PreferenceManager.sharedInstance
            .putMap(Keys.PROFILE_MAP.toString(), map);


        mView.profileDidReceived(registrationResponse);
      }else {
        throw Exception('Failed to load post');
      }

  }
   @override
   void doFileUpload(File file) async {
     String userId=await PreferenceManager.sharedInstance.getString(Keys.USER_ID.toString());
     String token=await PreferenceManager.sharedInstance.getString(Keys.ACCESS_TOKEN.toString());
     var response = await DioUtils.fileUpload(userId,token,APIS.fileupload+userId,file,Constants.documentType1);
     print(response);

   }
}