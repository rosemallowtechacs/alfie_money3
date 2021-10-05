
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
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../KYCimage.dart';
import '../OtpScreen.dart';

class BankDetailsView extends BaseView {
  void submitBtnDidTapped() {}

  void registrationDidSucceed() {}

  void registrationDidFailed(String invalidFields) {}

}

class BankDetailPresenter {
  void doRegistration(Map registrationData) {}
}

/////////////////////////////////////////////////////////////////////////////////////////////
class BankDetailsPresenterImpl extends BasePresenter<BankDetailsView>
    implements BankDetailPresenter {
   BankDetailsPresenterImpl(BankDetailsView view) : super(view);
  ProgressDialog pr;

  String verificationId, smsCode;
  bool codeSent = false;
  @override
  void doRegistration(Map registrationData) async {
    mView.onNetworkCallStarted("Loading...");
    print(registrationData);
    BaseApiResponse response = await DioUtils.reqeust(APIS.register,
        method: RequestMethod.POST, formData: registrationData);
    mView.onNetworkCallEnded();
    switch (response.status) {
      case Status.SUCCESS:
        UserVerification registrationResponse =
        UserVerification.fromJson(response.data);
        if (registrationResponse.status == true) {
          mView.registrationDidFailed(registrationResponse.result);
        } else {
          mView.registrationDidSucceed();
        }
        break;

      case Status.DIO_ERROR:
        super.handleError(response.error);
        break;
    }
  }

}