
import 'dart:convert';
import 'package:creditscore/Apiservice/DioUtils.dart';
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

import '../KYCimage.dart';
import '../OtpScreen.dart';

class PasswordView extends BaseView {
  void submitBtnDidTapped() {}

  void registrationDidSucceed() {}

  void registrationDidFailed(String invalidFields) {}

}

class RegistrationPresenter {
  void doRegistration(Map registrationData) {}
}

/////////////////////////////////////////////////////////////////////////////////////////////
class PasswordPresenterImpl extends BasePresenter<PasswordView>
    implements RegistrationPresenter {
   PasswordPresenterImpl(PasswordView view) : super(view);
  ProgressDialog pr;

  String verificationId, smsCode;
  bool codeSent = false;
  @override
  void doRegistration(Map registrationData) async {
    mView.onNetworkCallStarted("Loading...");
    print(registrationData);
    BaseApiResponse response = await DioUtils.reqeust(APIS.register_user,
        method: RequestMethod.POST, formData: registrationData);
    mView.onNetworkCallEnded();
    switch (response.status) {
      case Status.SUCCESS:
        Registerusers registrationResponse = Registerusers.fromJson(response.data);
        await PreferenceManager.sharedInstance.putInt(Keys.MOBILE_NUM.toString(), registrationResponse.mobile);
        await PreferenceManager.sharedInstance.putBoolean(
            Keys.REGISTERED_.toString(), true);
        mView.registrationDidSucceed();
        break;

      case Status.DIO_ERROR:
        super.handleError(response.error);
        break;
    }
  }

}