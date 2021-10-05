
import 'dart:convert';
import 'dart:io';
import 'package:creditscore/Apiservice/DioUtils.dart';
import 'package:creditscore/Apiservice/Responce/ProfiledetailsResponce.dart';
import 'package:creditscore/Apiservice/Responce/UserVerification.dart';
import 'package:creditscore/Apiservice/base/BaseApiResponse.dart';
import 'package:creditscore/Apiservice/base/BasePresenter.dart';
import 'package:creditscore/Apiservice/base/BaseView.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import '../KYCimage.dart';
import '../OtpScreen.dart';

class ProfileView extends BaseView {
  void submitBtnDidTapped() {}
  void submitBtnFileUpload() {}
  void registrationDidSucceed() {}

  void registrationDidFailed(String invalidFields) {}

}

class ProfilePresenter {
  void doRegistration(String userid,Map registrationData) {}
  void doFileUpload(File file){
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////
class ProfilePresenterImpl extends BasePresenter<ProfileView>
    implements ProfilePresenter {
   ProfilePresenterImpl(ProfileView view) : super(view);


  String verificationId, smsCode;
  bool codeSent = false;
  @override
  void doRegistration(String userid,Map registrationData) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    mView.onNetworkCallStarted("Loading...");
    print(registrationData);
    BaseApiResponse response = await DioUtils.reqeust(APIS.profiledata+userid,
        method: RequestMethod.PUT, formData: registrationData);
    mView.onNetworkCallEnded();
    switch (response.status) {
      case Status.SUCCESS:
        Profiledetails registrationResponse = Profiledetails.fromJson(response.data);

        preferences.setString(Constants.firstName,registrationResponse.firstName);
        preferences.setString(Constants.lastName,registrationResponse.lastName);

        preferences.setString(Constants.icNumbe,registrationResponse.icNumber);
        preferences.setString(Constants.dob,registrationResponse.dob);

        preferences.setString(Constants.address1,registrationResponse.address1);
        preferences.setString(Constants.address2,registrationResponse.address2);
        preferences.setString(Constants.emailId,registrationResponse.email);

        print(registrationResponse.email);


        ////profile data
        Map<String, dynamic> map = Map();
        map[ProfileKeys.FIRSTNAME_.toString()] = registrationResponse.firstName;
        map[ProfileKeys.LASTNAME_.toString()] = registrationResponse.lastName;
        map[ProfileKeys.ICNUM_.toString()] = registrationResponse.icNumber;
         map[ProfileKeys.ZIPCODE_.toString()] = registrationResponse.zipCode;
         map[ProfileKeys.MOBILE_.toString()] = registrationResponse.mobile;
        map[ProfileKeys.EMAIL_.toString()] = registrationResponse.email;
        map[ProfileKeys.DOB_.toString()] = registrationResponse.dob;
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
        print("good therasa");

        print( await PreferenceManager.sharedInstance
            .getMap(Keys.PROFILE_MAP.toString()));

        mView.registrationDidSucceed();
        break;

      case Status.DIO_ERROR:
        super.handleError(response.error);
        break;
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