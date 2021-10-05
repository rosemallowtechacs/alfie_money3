
import 'dart:convert';
import 'package:creditscore/Apiservice/DioUtils.dart';
import 'package:creditscore/Apiservice/Responce/ForgotPaswordResponce.dart';
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

class ForgotView extends BaseView {
  void submitBtnDidTapped() {}

  void registrationDidSucceed(String msg) {}

  void registrationDidFailed(String invalidFields) {}

}

class ForgotPresenter {
  void doForgot(Map registrationData) {}
}

/////////////////////////////////////////////////////////////////////////////////////////////
class ForgotPresenterImpl extends BasePresenter<ForgotView>
    implements ForgotPresenter {
  ForgotPresenterImpl(ForgotView view) : super(view);

  @override
  void doForgot(Map registrationData) async {
    mView.onNetworkCallStarted("Loading...");
    print(registrationData);
    BaseApiResponse response = await DioUtils.changePassword(APIS.forgot,formData: registrationData);
    mView.onNetworkCallEnded();
    switch (response.status) {
      case Status.SUCCESSFORGOT:
        mView.registrationDidSucceed(response.reponceData);
       // mView.registrationDidSucceed(response.data);
       /* print(response.data);
        ForgotPasswordResponce forgotResponse =
        ForgotPasswordResponce.fromJson(response.data);
        if (forgotResponse.resultCode == 0) {
          mView.registrationDidSucceed(forgotResponse.result);
        }*/
        break;
      case Status.ERROR_CHANGE_PASSWORD:
        mView.registrationDidFailed(response.reponceData);
        // mView.registrationDidSucceed(response.data);
        /* print(response.data);
        ForgotPasswordResponce forgotResponse =
        ForgotPasswordResponce.fromJson(response.data);
        if (forgotResponse.resultCode == 0) {
          mView.registrationDidSucceed(forgotResponse.result);
        }*/
        break;

      case Status.DIO_ERROR:
        super.handleError(response.error);
        break;
    }
  }



}
